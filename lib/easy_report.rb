class EasyReport
  DEFAULT_STYLE = {
    'font' => {
      'size' => 12,
      'color' => Color::RGB.new(0, 0, 0)
    }
  }

  DEFAULT_HEADING = {
    'align' => :center,
    'bold' => true
  }

  DEFAULT_OPTIONS = {
    'pagenum_pattern' => "<PAGENUM> de <TOTALPAGENUM>"
  }

  DEFAULT_NUMBERING = {
    'align' => :right,
    'position' => :top,
    'offset' => 0,
  }

  def initialize(data, options=nil)
    @data = data
    @options = DEFAULT_OPTIONS
    @options.update(options) unless options.nil?
    load(data['config_file'])
    build
  end

  def render
    return @pdf.render
  end

  private

  def load(filename)
    filepath = "#{Rails.root.to_s}/config/reports/#{filename}"
    config = YAML::load(File.open(filepath))
    @settings = config['report']['settings']
    @body = config['report']['body']
  end

  def build
    @pdf = PDF::Writer.new :paper => @settings['page']['size'],
      :orientation => @settings['page']['orientation']
    @pdf.text_render_style(0)
    1.upto(@body.length) do |i|
      type = @body[i].keys()[0]
      if type == 'image':
        render_image(@body[i][type])
      elsif type == 'text':
        render_text(@body[i][type])
      elsif type == 'table':
        render_table(@body[i][type])
      end
    end
    render_page_number
  end

  def render_image(element)
    align = get_align(element['align'])
    filepath = get_image_path(element['filename'])
    next if filepath.nil?
    @pdf.image filepath, :justification => align
  end

  def render_text(element)
    align = get_align(element['align'])
    font = get_font(element['font'])
    @pdf.fill_color(font['color'])
    if element['spacing'].nil?
      @pdf.text @data[element['field']], :font_size => font['size'], :justification => align
    else
      @pdf.text @data[element['field']], :font_size => font['size'], :justification => align, :spacing => element['spacing']
    end
  end

  def render_table(element)
    @pdf.text ' ', :font_size => 9
    font = get_font(element['font'])
    head = get_table_heading(element['heading'])
    table = PDF::SimpleTable.new
    table.column_order = @data['columns']
    table.show_lines = get_table_borders(element['borders'])
    table.font_size = font['size']
    element['columns'].each do |key, value|
      col = PDF::SimpleTable::Column.new(key)
      col.justification = get_align(value['align'])
      unless value['width'].nil?
        col.width = value['width']
      end
      heading = PDF::SimpleTable::Column::Heading.new(value['label'])
      heading.bold = head['bold']
      heading.justification = head['align']
      col.heading = heading
      table.columns[key] = col
    end
    table.data.replace @data[element['field']]
    table.render_on(@pdf)
    @pdf.text ' ', :font_size => 9
  end

  def render_page_number
    numbering = get_numbering(@settings['page']['numbering'])
    top = 0
    left = 0
    if numbering['position'] == :top
      top = @pdf.page_height - @pdf.top_margin - numbering['offset'] + 3
    else
      top = @pdf.bottom_margin + numbering['offset'] - 3
    end
    @pdf.pageset.each_with_index do |page, index|
      num = index + 1
      pattern = @options['pagenum_pattern'].gsub(/<PAGENUM>/, num.to_s).gsub(/<TOTALPAGENUM>/, @pdf.pageset.size.to_s)
      if numbering['align'] == :left
        left = @pdf.left_margin
      elsif numbering['align'] == :right
        left = @pdf.page_width - @pdf.right_margin - @pdf.text_width(pattern)
      elsif numbering['align'] == :center
        left = (@pdf.page_width - @pdf.text_width(pattern))/2
      end
      @pdf.reopen_object(page.contents.first)
      @pdf.add_text(left, top, pattern, 9)
      @pdf.close_object
    end
  end

  def get_align(value)
    return :center if value.nil?
    return :center if value.downcase == 'center'
    return :left if value.downcase == 'left'
    return :right if value.downcase == 'right'
    return :full if value.downcase == 'justify'
  end

  def get_position(value)
    return :top if value.nil?
    return :top if value.downcase == 'top'
    return :bottom if value.downcase == 'bottom'
  end

  def get_image_path(filename)
    return nil if filename.nil?
    return "#{Rails.root.to_s}/public/images/#{filename}"
  end

  def get_font(element)
    font = DEFAULT_STYLE
    return font if element.nil?
    color = element['color']
    unless element['size'].nil?
      font['size'] = element['size'].to_i
    end
    unless color.nil?
      font['color'] = Color::RGB.new(color[0], color[1], color[2])
    end
    return font
  end

  def get_table_heading(element)
    head = DEFAULT_HEADING
    return head if element.nil?
    head['align'] = get_align(element['align'])
    unless element['bold'].nil?
      head['bold'] = element['bold']
    end
    return head
  end

  def get_table_borders(value)
    return :all if value.nil?
    return :all if value.downcase == 'all'
    return :inner if value.downcase == 'inner'
    return :outer if value.downcase == 'outer'
    return :none if value.downcase == 'none'
  end

  def get_numbering(element)
    nmb = DEFAULT_NUMBERING
    return nmb if element.nil?
    nmb['align'] = get_align(element['align'])
    nmb['position'] = get_position(element['position'])
    nmb['offset'] = element['offset'] unless element['offset'].nil?
    return nmb
  end
end

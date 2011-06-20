module PaginationHelper
  DEFAULT_OPTIONS = {
    :name => :page,
    :window_size => 2,
    :always_show_anchors => true,
    :next_prev_links => false,
    :first_last_links => true,
    :prev_title => '&#171; Anterior',
    :next_title => 'Siguiente &#187;',
    :first_title => '&#171; Primero',
    :last_title => 'Último &#187;',
    :params => {},
    :action => '',
    :page_text => 'Page',
    :of_text => 'of',
  }
  
  # Este nuevo paginador permite usar estilo para cada tipo de enlace hacia las 
  # paginas (current, normal y deshabilitada). Ademas permite configurar los 
  # enlaces en los extremos del paginador con las opciones: anterior/siguiente, 
  # primero/ultimo o ninguno. Tambien se le pueden establecer las etiquetas a 
  # esos enlaces.
  # Este metodo aun es ineficiente porque sigue usando el paginate de Rails pero 
  # tiene mas funcionalides y se espera que para la v2.0 se pueda reemplazar por
  # completo el paginate por una funcion propia que optimice el acceso a la BD.
  
  def show_subset_pagination(paginator, options={}, html_options={})
    return '' if paginator.total_pages <= 1

    options = DEFAULT_OPTIONS.merge(options)
    next_prev_link = options[:next_prev_links]
    first_last_links = options[:first_last_links]
    show_anchors = options[:always_show_anchors]

    html=""
    pager = Pager.new(paginator, options, html_options, options[:action])

    if show_anchors and not pager.first?
      l = (pager.first == pager.current) ? pager.link_to_current : pager.link_to_page(pager.first)
      html << l
      html << ' ... ' if pager.away_from_first?
      html << ' '
    end

    pager.wp_first.upto(pager.wp_last) do |i|
      if i == pager.current
        html << pager.link_to_current
      else
        html << pager.link_to_page(i)
      end
      html << ' '
    end

    if show_anchors and not pager.last?
      html << ' ... ' if pager.away_from_last?
      l = (pager.last == pager.current) ? pager.link_to_current : pager.link_to_page(pager.last)
      html << l
      html << ' '
    end

    if next_prev_link
      temp = html
      html = pager.link_to_prev
      html << ' ' + temp + ' '
      html << pager.link_to_next
    elsif first_last_links
      temp = html
      html = pager.link_to_first
      html << ' ' + temp + ' '
      html << pager.link_to_last
    end

    return html
  end

  def show_pagination(paginator, options={}, html_options={})
    return '' if paginator.total_pages <= 1

    options = DEFAULT_OPTIONS.merge(options)

    pager = Pager.new(paginator, options, html_options, options[:action])
    html = pager.link_to_first
    html << pager.link_to_prev
    html << pager.pages_info
    html << pager.link_to_next
    html << pager.link_to_last

    return html
  end

  class Pager
    attr_reader :first, :last, :current, :previous, :next, :wp_first, :wp_last

    def initialize(paginator, options, html_options, name)
      @first = 1
      @current = paginator.current_page
      @last = paginator.total_pages
      @previous = paginator.previous_page
      @next = paginator.next_page
      @options = options
      @html_options = options
      @action = name
      wsize = options[:window_size]

      @wp_first = ((@current - wsize) < @first) ? @first : (@current - wsize)
      @wp_last = ((wsize + @current) > @last) ? @last :(wsize + @current)

      @wp_first = @options[:always_show_anchors] ? @wp_first + 1 : @wp_first
      @wp_last = @options[:always_show_anchors] ? @wp_last - 1 : @wp_last
    end

    def away_from_first?
      return (@wp_first - @first > 1) ? true : false
    end

    def away_from_last?
      return (@last - @wp_last > 1) ? true : false
    end

    def first?
      return (@wp_first == @first) ? true : false
    end

    def last?
      return (@wp_last == @last) ? true : false
    end

    def link_to_prev
      nav_link(@first, @previous, @options[:prev_title], 'prev')
    end

    def link_to_next
      nav_link(@last, @next, @options[:next_title], 'next')
    end

    def link_to_first
      nav_link(@first, @first, @options[:first_title], 'first')
    end

    def link_to_last
      nav_link(@last, @last, @options[:last_title], 'last')
    end

    def link_to_page(page)
      "<a class='page' href='#{@action}?page=#{page.to_i}'>#{page.to_s}</a>"
    end

    def link_to_current
      "<span class='current'>" + @current.to_s + "</span>" 
    end

    def nav_link(value, page, text, link_class='')
      if @current == value
        "<span class='nav disabled_#{link_class}'>#{text}</span>"
      else
        "<a class='nav #{link_class}' href='#{@action}?page=#{page.to_i}'>#{text}</a>"
      end
    end

    def pages_info
      "<span class='info'>#{@options[:page_text]} #{@current} #{@options[:of_text]} #{@last}</span>"
    end
  end

end

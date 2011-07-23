#require 'pdf/writer'

class MyPDF
  BASE_OPTIONS = {
    :font => ['Arial','',9], 
    :forecolor => ['0','0','0'], 
    :bgcolor => nil,
    :border => 0,
    :align => 'L',
    :width => 0,
    :margin => 0,
    :line_height => 3
  }
  
   # :TODO : Método que verifique la existencia de los campos básicos para la
   # generación del reporte
  def initialize(data, config, options)
    @data = data
    @config = config
    #@options = options
    
    super(@config['page']['orientation'], 'mm', @config['page']['size'])
    SetMargins(@config['page']['margins'], 10)
    SetAutoPageBreak(true, 20)
    
    @headercfg = @config['header']
    @bodycfg = @config['body']
    @footercfg = @config['footer']
    @groupcfg = @config['body']['grouping']
    @subtotalcfg = @config['body']['subtotal']
    @totalcfg = @config['body']['total']
    
    @groups = {}
    @groupcfg.each do |key, value|
      @groups[@groupcfg[key]['field']] = nil
    end
    puts @groups.inspect
    
    @columnas = @bodycfg['columns'].length
    @totales = Array.new(@columnas, nil)
    @subtotales = Array.new(@columnas, nil)
  end

private
  # Toma un estilo proveniente de tag y lo procesa. Si el estilo no existe 
  # crea uno por defecto para evitar que el programa deje de funcionar
  def get_estilo (tag)
    base = BASE_OPTIONS.clone()
    return base if tag == nil
    
    unless tag['font'].nil?
      tag['font'][1] = (tag['font'][1].nil?) ? '': tag['font'][1]
      base[:font] = tag['font']
      base[:line_height] = tag['font'][2].to_i / 2
    end
    
    base[:forecolor] = tag['forecolor'] unless tag['forecolor'].nil?
    base[:bgcolor] = tag['bgcolor'] unless tag['bgcolor'].nil?
    base[:border] = tag['border'] unless tag['border'].nil?
    base[:align] = tag['align'] unless tag['align'].nil?
    base[:width] = tag['width'] unless tag['width'].nil?
    base[:margin] = tag['margin'] unless tag['margin'].nil?
    
    return base
  end
  
  def set_cell(texto, estilo, ln=0)
    fill = 0
    unless estilo[:bgcolor].nil?
      fill = 1
      SetFillColor(estilo[:bgcolor][0].to_i, estilo[:bgcolor][1].to_i, estilo[:bgcolor][2].to_i)
    end
    
    unless estilo[:forecolor].nil?
      SetTextColor(estilo[:forecolor][0].to_i, estilo[:forecolor][1].to_i, estilo[:forecolor][2].to_i)
    end
    SetFont(estilo[:font][0], estilo[:font][1], estilo[:font][2].to_i)
    
    Cell(estilo[:margin], estilo[:font][2]/2, '', estilo[:border]) if estilo[:margin] > 0
    estilo[:width] -= estilo[:margin] if estilo[:width] > 0
    
    Cell(estilo[:width], estilo[:font][2]/2, texto, estilo[:border], 0, estilo[:align], fill)
    Ln(estilo[:line_height]) unless ln.zero?
  end
  
  def print_image
    path = "#{RAILS_ROOT}/public/images/#{@headercfg['image']['path']}"
    w = @headercfg['image']['width']
    h = @headercfg['image']['height']
    x = @headercfg['image']['x']
    y = @headercfg['image']['y']
    Image(path, x, y, w, h)
    Ln(@headercfg['image']['separator'].to_i)
  end
  
  def print_date_page_number
    estilo = get_estilo(nil)
    estilo[:align] = 'R'
    set_cell("Fecha de Reporte: #{Date.today.strftime("%d-%m-%Y")}", estilo, 1)
    set_cell("Pagina #{PageNo()}", estilo, 1)
  end
  
  def print_title
    title = @headercfg['title']
    estilo = get_estilo(@headercfg['style'])
    SetTitle(title)
    set_cell(title, estilo, 0)
    Ln(10)
  end
  
  # Crea el encabezado de la tabla para el reporte
  def print_body_header
    estilo = get_estilo(@bodycfg['header']['style'])
    
    1.upto(@columnas) do |i|
      texto = @bodycfg['columns'][i]['label']
      estilo[:width] = @bodycfg['columns'][i]['style']['width']
      # :TODO: Soporte para titulos con multiples lineas
      set_cell(texto, estilo, 0)
    end
    nueva_linea(estilo)
  end
  
  def print_record(i, valor)
    precision = @bodycfg['columns'][i]['precision'] unless @bodycfg['columns'][i]['precision'].nil?
    estilo = get_estilo(@bodycfg['columns'][i]['style'])
    
    sumar_subtotal(i-1, valor) if sumar?(@bodycfg['columns'][i])
    
    val = aplicar_precision(valor, precision)
    set_cell(val, estilo, 0)
  end
  
  # ---- Funciones utilitarias ----
  
  def aplicar_precision(campo, precision, default=' ')
    return default if campo.nil?
    
    unless precision.nil?
      valor = PDFHelper.round(campo, {:precision => precision.to_i})
    else
      valor = campo.to_s
    end
  end
  
  def borrar_subtotales
    @subtotales = Array.new(@columnas, nil)
  end
  
  def sumar_subtotal(indice, valor)
    return if valor.nil?
    
    if @subtotales[indice].nil?
      @subtotales[indice] = valor
    else
      @subtotales[indice] += valor
    end
  end
  
  def sumar_total(indice, valor)
    return if valor.nil?
    
    if @totales[indice].nil?
      @totales[indice] = valor
    else
      @totales[indice] += valor
    end
  end
  
  def aplicar?(item)
    return (is_valid?(item) and (not item['apply'].nil?) and (item['apply'] == 'Y'))
  end
  
  def sumar?(item)
    return (is_valid?(item) and (not item['sum'].nil?) and (item['sum'] == 'Y'))
  end
  
  def nueva_linea(estilo, mult=1)
    Ln(estilo[:line_height]*mult)
  end
=begin
  def print_subtitulo
    return if (@options['subtitulo'].nil? or @subtcfg.nil?)
    
    estilo = get_estilo(@subtcfg['estilo'])
    align = @subtcfg['alineacion']
    nueva_linea(estilo, 0.5)
    set_cell(0, @options['subtitulo'], align, estilo)
    nueva_linea(estilo, 2)
  end
=end
  
  def print_group_header(item)
    #@groupcfg.each do |key, value|
    estilo = get_estilo(@groupcfg[1]['style'])
    title = @groupcfg[1]['label']
    nueva_linea(estilo, 0.5)
    set_cell("#{title}: #{item}", estilo)
    nueva_linea(estilo)
    #end
  end
  
  def print_subtotal
    if aplicar?(@subtotalcfg)
      texto = @subtotalcfg['label']
      estilo = get_estilo(@subtotalcfg['style'])
    end
    
    if (not @subtotales[0].nil?) and aplicar?(@subtotalcfg)
      estilo = get_estilo(@bodycfg['header']['style'])
      set_cell(texto, estilo, 1)
    end
    
    1.upto(@columnas) do |i|
      precision = @bodycfg['columns'][i]['precision']
      estilo[:width] = @bodycfg['columns'][i]['style']['width']
      estilo[:align] = @bodycfg['columns'][i]['style']['align']
      valor = ((i == 1) and (@subtotales[i-1].nil?)) ? texto : ' '
      if sumar?(@bodycfg['columns'][i])
        sumar_total(i-1, @subtotales[i-1])
        valor = aplicar_precision(@subtotales[i-1], precision)
      end
      set_cell(valor, estilo) if aplicar?(@subtotalcfg)
    end
    
    nueva_linea(estilo) if aplicar?(@subtotalcfg)
  end
  
  def print_total
    return unless aplicar?(@totalcfg)
    
    texto = @totalcfg['label']
    estilo = get_estilo(@totalcfg['style'])
    nueva_linea(estilo) if  is_valid?(@subtotalcfg)
    
    unless @totales[0].nil?
      estilo = get_estilo(@bodycfg['header']['style'])
      set_cell(texto, estilo, 1)
    end
    
    1.upto(@columnas) do |i|
      precision = @bodycfg['columns'][i]['precision']
      estilo[:width] = @bodycfg['columns'][i]['style']['width']
      estilo[:align] = @bodycfg['columns'][i]['style']['align']
      valor = ((i == 1) and (@totales[i-1].nil?)) ? texto : ' '
      valor = aplicar_precision(@totales[i-1], precision) if sumar?(@bodycfg['columns'][i])
      set_cell(valor, estilo)
    end
    
    nueva_linea(estilo)
  end
  
  # Valida que un item del .yml no sea nil
  def is_valid?(item)
    return (not item.nil?)
  end
  
public
  def generate()
    AddPage()
    Body()
    Output()
  end
  
  def Header
    print_image()
    print_date_page_number()
    print_title()
    print_body_header()
  end
  
  def Body
    last = nil
    group_field = @groupcfg[1]['field']
    
    # Filas
    @data.each do |hash|
      if hash[group_field] != last
        # Totalizar
        print_subtotal() if not last.nil?
        last = hash[group_field]
        print_group_header(last)
        borrar_subtotales()
      end
      
      # Columnas
      1.upto(@columnas) do |i|
        j = @bodycfg['columns'][i]['field']
        print_record(i, hash[j])
      end
      estilo = get_estilo(@bodycfg['header']['estilo'])
      nueva_linea(estilo,1.4)
    end
    
    print_subtotal()
    print_total() if not last.nil?

  end
  
  def Footer
    SetY(-15);
    estilo = get_estilo(@footercfg['style'])
    set_cell(@footercfg['label'], estilo)
  end
end


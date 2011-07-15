class PDFHelper
 
  def self.round(number, options = {})
    options = options.stringify_keys
    precision = options["precision"] || 2
    unit = options["unit"] || ""
    separator = precision > 0 ? options["separator"] || "," : ""
    delimiter = options["delimiter"] || "."
    
    begin
      parts = number_with_precision(number, precision).split('.')
      unit + number_with_delimiter(parts[0], delimiter) + separator + parts[1].to_s
    rescue
      number
    end
  end
  
  def self.number_with_delimiter(number, delimiter=",", separator=".")
    begin
       parts = number.to_s.split('.')
       parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
       parts.join separator
    rescue
      number
    end
   end

  def self.parsear_fecha(fecha)
    return Date.parse(fecha).strftime("%d-%m-%Y")
  end
  
  def self.form_to_fechas(params)
    fecha1 = params['desde(1i)'] + '-' + params['desde(2i)'] + '-' + params['desde(3i)']
    fecha2 = params['hasta(1i)'] + '-' + params['hasta(2i)'] + '-' + params['hasta(3i)']
    return fecha1, fecha2
  end

  def self.number_with_precision(number, precision=3)
   "%01.#{precision}f" % number
  rescue
   number
  end
end

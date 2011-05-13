class Recipe < ActiveRecord::Base
  
  def import(filepath)
    begin
      fd = File.open(filepath, 'r')
      continue = fd.gets()
      while (continue)
        0.upto(7) { |i| fd.gets() }
        header = fd.gets().split(/\t/)
        @version = header[0]
        @nombre = header[1]
        @fecha = header[2]
        @items = []
        fd.gets()
        puts "#{@version} - #{@nombre} - #{@fecha}"
        while (true)
          item = fd.gets().split(/\t/)
          break if item[0].strip() == '-----------'
          code = item[2].split(' ')[0]
          @items << {:amount=>item[0], :priority=>item[1], :code=>code, :per=>item[3].strip()}
        end
        @total = fd.gets().strip()
        puts "#{@items.length} items. Total: #{@total}"
        continue = fd.gets().strip()
        break if continue.nil? or continue == '='
      end
    rescue => err
      puts "Exception: #{err}"
      return false
    end
  end
end

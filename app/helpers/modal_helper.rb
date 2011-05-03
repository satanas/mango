module ModalHelper
  
  module Modal
    class Popup
      attr_reader :message, :title, :caption, :onclick
      
      def initialize(title, message, caption='Aceptar')
        @title = title
        @message = message
        @caption = caption
        @onclick = 'javascript: Element.remove("modal"); window.onscroll = null;'
      end
      
      def to_html
        html = "<div class='pop title'>#{@title}</div>"
        html << "<div class='pop message'>#{@message}</div>"
        html << "<div class='pop button'><input type='button' value='#{@caption}'
          onclick='#{@onclick}' /></div>"
        
        return html
      end
    end
    
    class GenericDialog
      attr_reader :dialog
      
      def initialize(dialog)
        @dialog = dialog
      end
      
      def to_html
        return @dialog
      end
    end
    
    class GenericCatalog
      attr_reader :info, :objetos
      
      def initialize(arr_info, arr_objectos)
        @info = arr_info
        @objetos = arr_objectos
        @totales = Array.new(@objetos.length, 0)
        @onclick = 'javascript: Element.remove("modal"); window.onscroll = null;'
      end
      
      def to_html
        html = '<div><table><thead><tr><th>Sel.</th>'
        @info.each do |item|
          html << "<th>#{item['titulo']}</th>"
        end
        html << '</tr></thead>'
        @objetos.each do |obj|
          html << '<tr><td><input type="checkbox"/></td>'
          0.upto(@info.length-1) do |i|
            valor = obj.send(@info[i]['campo'])
            @totales += valor.to_f if @info[i]['sumar']
            html << "<td>#{valor}</td>"
          end
        end
        html << '</tr></table><br/>'
        html << "<div class='submit'><input type='submit' value='Aceptar' onclick='#{@onclick}'/></div></div>"
        return html
      end
    end
  end
  
  def render_popup_dialog
    return if @popup.nil?
    
    html = content_tag('div', 
      content_tag('div', '', :class=>'background') + 
      content_tag('div', @popup.to_html, :class=>'container'),
      :id=>'modal')
    
    html << javascript_tag('
      window.onscroll = function () {
        var xoffset = 0;
        var yoffset = 0;
        if (document.all) {
          yoffset = window.document.documentElement.scrollTop;
          xoffset = window.document.documentElement.scrollLeft;
        } else {
          xoffset = window.pageXOffset;
          yoffset = window.pageYOffset;
        }
        $(\'modal\').style.top = yoffset + \'px\';
        $(\'modal\').style.left = xoffset + \'px\';
      };
      window.onscroll();')

    return html
  end
  
end

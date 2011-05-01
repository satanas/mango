module FlashHelper

  def render_flash_notice
    return content_tag('div', '', :id=>'notice') unless flash[:notice]
    
    flash[:type] = flash[:type] || 'info'
    html = content_tag('div', flash[:notice], :id=>'notice', :class=>"notice #{flash[:type]}")
    html += javascript_tag('setTimeout("new Effect.Opacity(\'notice\', {from:1, to:0});",5000);
      setTimeout("$(\'notice\').update('');",5800);')

    flash[:notice] = nil
    return html
  end
  
end

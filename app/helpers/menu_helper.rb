module MenuHelper
  
  def render_menu
    c = params[:controller]
    a = params[:action]
    if c == 'recipes' and 'index'
      menu = menu_for_recipes_index
    end

    html = content_tag(:div, menu, :id => 'menu')
    #html += content_tag(:div, nil, :class => 'clearfix')
    return html
  end

  def menu_for_recipes_index
    menu = content_tag(:p, 'Lista de recetas')
  end
end

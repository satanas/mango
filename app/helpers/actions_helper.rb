module ActionsHelper
  def render_action_show(url)
    image = image_tag('action-show.png', :alt=>'Mostrar') #, :title=>'Mostrar', :width=>28, :height=>28)
    return link_to image + " Mostrar", url, :class => 'action'
  end

  def render_action_edit(url)
    image = image_tag('action-edit.png', :alt=>'Editar') #, :title=>'Editar', :width=>28, :height=>28)
    return link_to image + "Editar", url, :class => 'action'
  end

  def render_action_delete(url, confirm)
    image = image_tag('action-delete.png', :alt=>'Borrar') #, :title=>'Borrar', :width=>28, :height=>28)
    return link_to image + " Eliminar", url, :class => 'action', :method => :delete, :confirm =>confirm
  end
end

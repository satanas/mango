module ActionsHelper
  def render_action_show(url)
    image = image_tag('action-show.png', :alt=>'Mostrar')
    return link_to image + " Mostrar", url, :class => 'action'
  end

  def render_action_edit(url)
    image = image_tag('action-edit.png', :alt=>'Editar')
    return link_to image + "Editar", url, :class => 'action'
  end

  def render_action_delete(url, confirm)
    image = image_tag('action-delete.png', :alt=>'Borrar')
    return link_to image + " Eliminar", url, :class => 'action', :method => :delete, :confirm =>confirm
  end

  def render_remote_action_show(url)
    image = image_tag('action-show.png', :alt=>'Mostrar')
    return link_to image, url, :remote=>true
  end

  def render_remote_action_delete(url , confirm)
    image = image_tag('action-delete.png', :alt=>'Borrar')
    return link_to image + " Eliminar", url, :method => :delete, :remote=>true, :confirm =>confirm, :html=>{:class => 'action'}
  end

end

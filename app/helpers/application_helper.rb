# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def alternate_row_class(num)
    class_row = (num % 2).zero? ? 'blank' : 'alternate'
    return class_row, num + 1
  end

  def render_error_messages(messages)
    return '' if messages.blank?
    errors = content_tag(:div, 
      content_tag(:div, '', :class=>'background') +
      content_tag(:div, 
        messages + 
        content_tag(:div, button_to_function('Cerrar', 'close_error_dialog()', :class=>'err_btn'), :id=>'errorButton'),
      :id=>'errorDialog'),
    :id=>'modal')
    return errors
  end
end

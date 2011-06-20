# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def alternate_row_class(num)
    class_row = (num % 2).zero? ? 'blank' : 'alternate'
    return class_row, num + 1
  end
end

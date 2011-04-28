# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format 
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# extender la clase Inflector
module Inflector
  def pluralize(word)
    result = word.to_s.dup

    if word.empty? || inflections.uncountables.include?(result.downcase)
      result
    else
      inflections.plurals.each { |(rule, replacement)| result.gsub!(rule, replacement) }
      result
    end
  end
  
  def singularize(word)
    result = word.to_s.dup
    if inflections.uncountables.include?(result.downcase)
      result
    else
      inflections.singulars.each { |(rule, replacement)| result.gsub!(rule, replacement) }
      result
    end
  end

end
#para que pluralice en castellano - WY
ActiveSupport::Inflector.inflections.clear
ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural /([aeiout])([A-Z]|_|$)/, '\1s\2'
  inflect.plural /([rlnd])([A-Z]|_|$)/, '\1es\2'
  inflect.singular /([aeiout])s([A-Z]|_|$)/, '\1\2'
  inflect.singular /([rlnd])es([A-Z]|_|$)/, '\1\2'
end

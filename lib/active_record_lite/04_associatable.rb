require_relative '03_searchable'
require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key,
  )

  def model_class
    # ...
  end

  def table_name
    # ...
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    # ...
    if options.empty?
      @foreign_key = "#{name}_id".to_sym
      @class_name = name.capitalize
      @primary_key = :id
    else
      @foreign_key = options[:foreign_key]
      @class_name = options[:class_name]
      @primary_key = options[:primary_key]
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    # ...
    if options.empty?
      @foreign_key = "#{self_class_name.downcase}_id".to_sym
      @class_name = name.capitalize.singularize
      @primary_key = :id
    else
      @foreign_key = options[:foreign_key]
      @class_name = options[:class_name]
      @primary_key = options[:primary_key]
    end
  end
end

module Associatable
  # Phase IVb
  def belongs_to(name, options = {})
    # ...
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase V. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
end

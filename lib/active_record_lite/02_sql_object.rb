require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'

class MassObject
  def self.parse_all(results)
    # ...
    array = []
    results.each do |result|
      array << self.new(result)
    end
    array
  end
end

class SQLObject < MassObject
  def self.table_name=(table_name)
    # ...
    @table_name=table_name
  end

  def self.table_name
    # ...
    class_name=self.to_s.downcase
    plural="#{class_name}s"
    return plural
  end

  def self.all
    # ...

    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
      #{table_name}

      SQL
      self.parse_all(results)
  end

  def self.find(id)
    # ...
    results = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
      #{table_name}
      WHERE
      #{table_name}.id = ?
      LIMIT 1
      SQL
      self.parse_all(results).first

  end

  def insert
    # ...

    col_names = self.class.attributes.join(", ")
    question_marks = (["?"] * self.class.attributes.length).join(", ")
    values = attribute_values
    results = DBConnection.execute(<<-SQL, *values)
      INSERT INTO #{self.class.table_name} (#{col_names})
      VALUES (#{question_marks})

    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def save
    # ...
    if self.id.nil?
      insert
    else
      update
    end
  end

  def update
    # ...
     values = attribute_values
     set_line = self.class.attributes.map{|attribute| "#{attribute} = ?"}.join(", ")
     my_id=self.id
     results = DBConnection.execute(<<-SQL, *values, my_id )
       UPDATE #{self.class.table_name}
       SET #{set_line}
       WHERE id = ?
     SQL
  end

  def attribute_values
    # ...

    self.class.attributes.map {|attribute| self.send(attribute)}
  end
end

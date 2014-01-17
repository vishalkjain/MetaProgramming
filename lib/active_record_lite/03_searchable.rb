require_relative 'db_connection'
require_relative '02_sql_object'

module Searchable
  def where(params)
    # ...
    where_line = params.map{|key, value| "#{key} = ?" }.join(" AND ")
    values = params.values
    results = DBConnection.execute(<<-SQL, *values )
      SELECT *
      FROM #{table_name}
      WHERE #{where_line}
    SQL
    parse_all(results)
  end
end

class SQLObject
  extend Searchable
  # Mixin Searchable here...
end


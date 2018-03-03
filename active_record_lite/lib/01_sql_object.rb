require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns
    cols = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      LIMIT
        0
    SQL
    # ...
    cols.first.map!(&:to_sym)
    @columns = cols.first
  end

  def self.finalize!
    self.columns.each do |col_name|
      define_method(col_name) do
        self.attributes[col_name]
      end

      define_method("#{col_name}=") do |val|
        self.attributes[col_name] = val
      end
    end

  end

  def self.table_name=(table_name)
    @table_name = table_name
    # ...
  end

  def self.table_name
    return @table_name if @table_name
    @table_name = "#{self}".tableize
    # ...
  end

  def self.all
    everything = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL

    parse_all(everything)
    # ...
  end

  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |name, value|
      # make sure to convert keys to symbols
      name = name.to_sym
      if self.class.columns.include?(name)
        self.send("#{name}=", value)
      else
        raise "unknown attribute '#{name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}

    # ...
  end

  def attribute_values
    self.class.columns.map { |attr| self.send(attr) }
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end

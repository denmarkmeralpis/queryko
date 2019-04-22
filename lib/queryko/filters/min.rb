require "queryko/filters/base"

class Queryko::Filters::Min < Queryko::Filters::Base
  def intialize(options = {}, feature)
    super options, feature
  end

  def perform(collection, token)
    collection.where("\"#{table_name}\".\"#{column_name}\" >= ?", token)
  end
end
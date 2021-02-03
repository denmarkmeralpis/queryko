require "queryko/filters/base"

class Queryko::Filters::Search < Queryko::Filters::Base
  attr_reader :cond, :token_format
  def initialize(options = {}, feature)
    @cond = options.fetch(:cond) { :like }
    @token_format = options[:token_format] || '%token%'
    super(options, feature)
  end

  def perform(collection, token, query_object = nil)
    query_cond, query_token = format_query_params(collection, token)
    table_property = "#{table_name}.#{column_name}"

    collection.where("#{table_property} #{query_cond} ?", query_token)
  end

  def format_query_params(collection, token)
    query_token = token_enum_value(collection, token).to_s

    case cond.to_sym
    when :like
      ['LIKE', token_format.gsub('token', query_token)]
    when :eq
      ['=', query_token]
    when :neq
      ['IS NOT', query_token]
    end
  end

  private

  def token_enum_value(collection, token)
    class_enum = collection.try(column_name.to_s.pluralize)

    if class_enum && class_enum[token.to_s]
      class_enum[token]
    else
      token
    end
  rescue StandardError => e
    token
  end
end

# frozen_string_literal: true

module Queryko
  module Filterer
    def filter_by_filters
      fields.each do |field, filter|
        paginate(filter) if ['limit', 'page'].include?(field.to_s)

        filter.each do |f|
          self.relation = f.call(relation, params[field], self) if params[field]
        end
      end
    end

    def paginate(filter)
      unless @paginated
      end
      @paginated ||= true
    end
  end
end

module Queryko
  module Filterer
    def filter_by_filters
      fields.each do |field, filter|
        # puts field
        # puts filter, filter.first.class.name
        self.relation = filter.first.perform(relation, params[field]) if params[field]
      end
    end
  end
end

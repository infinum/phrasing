module Phrasing
  class String
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def to_bool
      if major_version >= 5
        ActiveModel::Type::Boolean.new.cast(value)
      elsif major_version == 4 && minor_version >= 2
        ActiveRecord::Type::Boolean.new.type_cast_from_database(value)
      else
        ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
      end
    end

    private

    def major_version
      rails_version.first.to_i
    end

    def minor_version
      rails_version.second.to_i
    end

    def rails_version
      @rails_version ||= ::Rails.version.split('.')
    end
  end
end

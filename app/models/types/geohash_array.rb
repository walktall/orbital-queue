module Types
  class GeohashArray < ActiveRecord::Type::Text
    # db format to user input (string)
    def deserialize(value)
      if value.is_a?(Array)
        value.join(", ")
      else
        super
      end
    end

    # Convert user input to db format
    def serialize(value)
      if value.is_a?(String)
        value.split(",").map { |v| v.strip }
      else
        value
      end
    end

    def cast(value)
      serialize(value)
    end
  end
end

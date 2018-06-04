module Types
  class ValuePair < ActiveRecord::Type::Text
    # db format to user input (string)
    def deserialize(value)
      if value.is_a?(Hash)
        value.to_json
      else
        super
      end
    end

    # Convert user input to db format
    def serialize(value)
      if value.is_a?(String)
        v = "{#{value}}"
        if valid_json?(v)
          return JSON.parse(v)
        end
      end

      value
    end

    def cast(value)
      serialize(value)
    end

    private

    def valid_json?(json)
      begin
        JSON.parse(json)
        return true
      rescue Exception => e
        return false
      end
    end
  end
end

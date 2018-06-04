class JsonConfig < AbstractModel
  attr_accessor :vehicle_types

  attribute :location_id, :integer
  attribute :city_id, :integer
  attribute :country, :string
  attribute :city_name, :string
  attribute :location_name, :string
  attribute :vehicle_type_names, Types::ValuePair.new
  attribute :pickup_area_geo, Types::GeohashArray.new
  attribute :bay_area_geo, Types::GeohashArray.new

  attribute :welcome_message, :string
  attribute :welcome_back_message, :string
  attribute :out_of_queue_remind_message, :string
  attribute :out_of_queue_message, :string
  attribute :alert_message, :string
  attribute :update_message, :string
  attribute :readmore_link

  attribute :range_template, :string
  attribute :range_template_with_eta, :string


  # Integer, Send a message to driver after he has moved X positions in the queue.
  attribute :queue_position_multiple, :integer, :default => 5
  # Hash, The frequency of the notification based on current position of drivers
  attribute :queue_position_dynamic_multiple, Types::ValuePair.new
  # Number of ignored booking to reset Driver's position in queue
  attribute :ignore_quota, :integer, default: 2
  # Number of seconds after the driver turn off app and to be moved to the last of queue / Number of minutes after dax moving out
  # of X area and move to the last of queue
  attribute :mercy_period_in_sec, :integer, default: 300
  # Number of minutes for dax to come back to X after pax cancels
  attribute :pax_cancel_record_ttl_in_sec, :integer, default: 900
  # We will only send one notification in the snooze period
  # e.g. If you get a reminder at 12:00 and the next reminder will be at 12:05 if this number is set to 5 mins.
  attribute :remind_snooze_time_in_sec, :integer, default: 180
  # When will the remind msg be sent if drivers are in danger of getting kicked out
  attribute :remind_before_in_sec, :integer, default: 180

  # The key mapping of the json config keys to attributes
  # e.g.  { locID: :location_id } means the "locID" in the json config maps to attribute location_id
  JSON_KEY_MAP = {
    locID: :location_id,
    cityID: :city_id,
    cityName: :city_name,
    locationName: :location_name,
    vehicleTypes: :vehicle_types,
    vehicleTypeNames: :vehicle_type_names,
    pickUpGeo: :pickup_area_geo,
    bayAreaGeo: :bay_area_geo,
    message: {
        messageContent:
            {
                alert_msg: :alert_message,
                update_msg: :update_message,
                welcome_msg: :welcome_message,
                welcomeback_msg: :welcome_back_message,
                remind_msg: :out_of_queue_remind_message,
                out_of_queue_msg: :out_of_queue_message,
            },
        rangeTemplate: :range_template,
        rangeTemplateWithEta: :range_template_with_eta,
        readMore: :readmore_link,
    },

    queueSpec: {
        queuePositionMultiple: :queue_position_multiple,
        queuePositionDynamicMultiple: :queue_position_dynamic_multiple,
        ignoreQuota: :ignore_quota,
        mercyPeriodInSec: :mercy_period_in_sec,
        paxCancelRecordTTLInSec: :pax_cancel_record_ttl_in_sec,
        remindSnoozeTimeInSec: :remind_snooze_time_in_sec,
        remindBeforeInSec: :remind_before_in_sec,
    }
  }

  # Serialize config object to JSON string
  def serialize_to_json
    hash = serialize_to_hash()

    JSON.pretty_generate(hash)
  end

  def serialize_to_compact_json
    serialize_to_hash().to_json
  end

  def serialize_to_hash
    generate_vehicle_types()

    hash = {}
    walk_key_map(JSON_KEY_MAP, hash)

    hash
  end

  # Construct config object from JSON
  def deserialize_from_json(str)
    raw_hash = JSON.parse(str)
    walk_key_map_reverse(JSON_KEY_MAP, ActiveSupport::HashWithIndifferentAccess.new(raw_hash))
    self
  end

  private

  def walk_key_map(map, hash)
    map.each_key do |k|
      v = map[k]
      if v.is_a?(Symbol)
        # assign value
        hash[k] = send(v)
      else
        hash[k] = {} unless hash[k]
        walk_key_map(map[k], hash[k])
      end
    end
  end

  def walk_key_map_reverse(map, hash)
    map.each_key do |k|
      v = map[k]
      if v.is_a?(Symbol)
        # restore value
        send("#{v}=", hash[k])
      else
        next unless hash[k]
        walk_key_map_reverse(map[k], hash[k])
      end
    end
  end

  def generate_vehicle_types
    self.vehicle_types = []
    if vehicle_type_names.is_a?(Hash)
      self.vehicle_types = vehicle_type_names.keys.map { |k| k.to_i }
    end
  end
end

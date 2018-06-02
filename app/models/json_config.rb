class JsonConfig < AbstractModel
  attribute :location_id, :integer
  attribute :city_id, :integer
  attribute :country, :string
  attribute :city_name, :string
  attribute :location_name, :string
  attribute :vehicle_type_names, :text
  attribute :pickup_area_geo, :string
  attribute :bay_area_geo, :string

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
  attribute :queue_position_dynamic_multiple, :text
  # Number of ignored booking to reset Driver's position in queue
  attribute :ignore_quota, :integer, default: 2
  # Number of seconds after the driver turn off app and to be moved to the last of queue / Number of minutes after dax moving out
  # of X area and move to the last of queue
  attribute :mercy_period_in_sec, :integer, default: 900
  # Number of minutes for dax to come back to X after pax cancels
  attribute :pax_cancel_record_ttl_in_sec, :integer, default: 900
  # We will only send one notification in the snooze period
  # e.g. If you get a reminder at 12:00 and the next reminder will be at 12:05 if this number is set to 5 mins.
  attribute :remind_snooze_time_in_sec, :integer, default: 180
  # When will the remind msg be sent if drivers are in danger of getting kicked out
  attribute :remind_before_in_sec, :integer, default: 180

  # The key mapping of the json config keys to attributes
  # e.g.  { locID: :location_id } means the "locID" in the json config maps to attribute location_id
  JSON_KEY_MAPPING = {
    locID: :location_id,
    cityID: :city_id,
    cityName: :city_name,
    locationName: :location_name,
    vehicleTypes: :vehicle_types,
    pickUpGeo: :pick_up_geo_array,
    bayAreaGeo: :bay_area_geo_array,
    vehicleTypeNames: :vehicle_type_names,
  }

  def serialize_to_json
    hash = {}
    hash[:locID] = location_id
    hash[:cityID] = city_id
    hash[:cityName] = city_name


  end
end

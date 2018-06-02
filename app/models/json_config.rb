class JsonConfig
  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :country, :city_id, :city_name, :location_name, :location_id, :vehicle_types,
                :pickup_area_geo, :bay_area_geo

  attr_accessor :welcome_message, :welcome_back_message, :out_of_queue_remind_message, :out_of_queue_message, :alert_message, :update_message,
                :readmore_link

  attr_accessor :range_template, :range_template_with_eta

  attr_accessor :queue_position_multiple, # Integer, Send a message to driver after he has moved X positions in the queue.
                # Hash, The frequency of the notification based on current position of drivers
                :queue_position_dynamic_multiple,
                # Number of ignored booking to reset Driver's position in queue
                :ignore_quota,
                # Number of seconds after the driver turn off app and to be moved to the last of queue / Number of minutes after dax moving out
                # of X area and move to the last of queue
                :mercy_period_in_sec,
                # Number of minutes for dax to come back to X after pax cancels
                :pax_cancel_record_ttl_in_sec,
                # We will only send one notification in the snooze period
                # e.g. If you get a reminder at 12:00 and the next reminder will be at 12:05 if this number is set to 5 mins.
                :remind_snooze_time_in_sec,
                # When will the remind msg be sent if drivers are in danger of getting kicked out
                :remind_before_in_sec

  def initialize
  end

  # This causes forms for settings to be submitted using PATCH instead of POST
  def persisted?
    true
  end
end

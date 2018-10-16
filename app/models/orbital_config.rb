class OrbitalConfig < ApplicationRecord
  attr_accessor :vehicle_types

  attribute :location_id, :integer
  attribute :city_id, :integer
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
  attribute :rank_template, :string
  attribute :range_template_with_eta, :string

  attribute :inbox_and_push_welcome_message_title, :string
  attribute :inbox_and_push_welcome_message_subtitle, :string
  attribute :inbox_and_push_welcome_message_category, :string
  attribute :inbox_and_push_welcome_message_content, :string
  attribute :inbox_and_push_welcome_message_button_text, :string
  attribute :inbox_and_push_welcome_message_button_link, :string

  attribute :inbox_and_push_welcome_back_message_title, :string
  attribute :inbox_and_push_welcome_back_message_subtitle, :string
  attribute :inbox_and_push_welcome_back_message_category, :string
  attribute :inbox_and_push_welcome_back_message_content, :string
  attribute :inbox_and_push_welcome_back_message_button_text, :string
  attribute :inbox_and_push_welcome_back_message_button_link, :string

  attribute :inbox_and_push_out_of_queue_remind_message_title, :string
  attribute :inbox_and_push_out_of_queue_remind_message_subtitle, :string
  attribute :inbox_and_push_out_of_queue_remind_message_category, :string
  attribute :inbox_and_push_out_of_queue_remind_message_content, :string
  attribute :inbox_and_push_out_of_queue_remind_message_button_text, :string
  attribute :inbox_and_push_out_of_queue_remind_message_button_link, :string

  attribute :inbox_and_push_out_of_queue_message_title, :string
  attribute :inbox_and_push_out_of_queue_message_subtitle, :string
  attribute :inbox_and_push_out_of_queue_message_category, :string
  attribute :inbox_and_push_out_of_queue_message_content, :string
  attribute :inbox_and_push_out_of_queue_message_button_text, :string
  attribute :inbox_and_push_out_of_queue_message_button_link, :string

  attribute :inbox_and_push_alert_message_title, :string
  attribute :inbox_and_push_alert_message_subtitle, :string
  attribute :inbox_and_push_alert_message_category, :string
  attribute :inbox_and_push_alert_message_content, :string
  attribute :inbox_and_push_alert_message_button_text, :string
  attribute :inbox_and_push_alert_message_button_link, :string

  attribute :inbox_and_push_update_message_title, :string
  attribute :inbox_and_push_update_message_subtitle, :string
  attribute :inbox_and_push_update_message_category, :string
  attribute :inbox_and_push_update_message_content, :string
  attribute :inbox_and_push_update_message_button_text, :string
  attribute :inbox_and_push_update_message_button_link, :string

  attribute :inbox_and_push_ttl_in_minute, :integer, default: 1
  attribute :inbox_and_push_readmore_link
  attribute :inbox_and_push_range_template, :string
  attribute :inbox_and_push_rank_template, :string
  attribute :inbox_and_push_range_template_with_eta, :string

  # Integer, Send a message to driver after he has moved X positions in the queue.
  attribute :queue_position_multiple, :integer, :default => 5
  # Hash, The frequency of the notification based on current position of drivers
  attribute :queue_position_dynamic_multiple, Types::ValuePair.new
  # Number of ignored booking to reset Driver's position in queue
  attribute :ignore_quota, :integer, default: 2
  # Number of canceled booking to reset Driver's position in queue
  attribute :cancel_quota, :integer

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

  validates :location_id, :city_id, :city_name, :location_name, :vehicle_type_names, :pickup_area_geo, :bay_area_geo, presence: true
  validates :welcome_message, :welcome_back_message, :alert_message, :update_message, presence: true
  validates :range_template, :range_template_with_eta, presence: true
  validate :geohashes_should_not_contain_invalid_chars, :vehicle_type_and_names_format, :queue_position_dynamic_multiple_format

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
        rankTemplate: :rank_template,
        rangeTemplateWithEta: :range_template_with_eta,
        readMore: :readmore_link,
    },
    messageV2: {
      messageTitle:
      {
          alert_msg: :inbox_and_push_alert_message_title,
          update_msg: :inbox_and_push_update_message_title,
          welcome_msg: :inbox_and_push_welcome_message_title,
          welcomeback_msg: :inbox_and_push_welcome_back_message_title,
          remind_msg: :inbox_and_push_out_of_queue_remind_message_title,
          out_of_queue_msg: :inbox_and_push_out_of_queue_message_title,
      },
      messageSubtitle:
      {
          alert_msg: :inbox_and_push_alert_message_subtitle,
          update_msg: :inbox_and_push_update_message_subtitle,
          welcome_msg: :inbox_and_push_welcome_message_subtitle,
          welcomeback_msg: :inbox_and_push_welcome_back_message_subtitle,
          remind_msg: :inbox_and_push_out_of_queue_remind_message_subtitle,
          out_of_queue_msg: :inbox_and_push_out_of_queue_message_subtitle,
      },
      messageCategory:
      {
          alert_msg: :inbox_and_push_alert_message_category,
          update_msg: :inbox_and_push_update_message_category,
          welcome_msg: :inbox_and_push_welcome_message_category,
          welcomeback_msg: :inbox_and_push_welcome_back_message_category,
          remind_msg: :inbox_and_push_out_of_queue_remind_message_category,
          out_of_queue_msg: :inbox_and_push_out_of_queue_message_category,
      },
      messageContent:
      {
          alert_msg: :inbox_and_push_alert_message_content,
          update_msg: :inbox_and_push_update_message_content,
          welcome_msg: :inbox_and_push_welcome_message_content,
          welcomeback_msg: :inbox_and_push_welcome_back_message_content,
          remind_msg: :inbox_and_push_out_of_queue_remind_message_content,
          out_of_queue_msg: :inbox_and_push_out_of_queue_message_content,
      },
      buttonText:
      {
          alert_msg: :inbox_and_push_alert_message_button_text,
          update_msg: :inbox_and_push_update_message_button_text,
          welcome_msg: :inbox_and_push_welcome_message_button_text,
          welcomeback_msg: :inbox_and_push_welcome_back_message_button_text,
          remind_msg: :inbox_and_push_out_of_queue_remind_message_button_text,
          out_of_queue_msg: :inbox_and_push_out_of_queue_message_button_text,
      },
      buttonLink:
      {
          alert_msg: :inbox_and_push_alert_message_button_link,
          update_msg: :inbox_and_push_update_message_button_link,
          welcome_msg: :inbox_and_push_welcome_message_button_link,
          welcomeback_msg: :inbox_and_push_welcome_back_message_button_link,
          remind_msg: :inbox_and_push_out_of_queue_remind_message_button_link,
          out_of_queue_msg: :inbox_and_push_out_of_queue_message_button_link,
       },
        ttlInMinute: :inbox_and_push_ttl_in_minute,
        rangeTemplate: :inbox_and_push_range_template,
        rangeTemplateWithEta: :inbox_and_push_range_template_with_eta,
        readMore: :inbox_and_push_readmore_link,
    },
    queueSpec: {
        queuePositionMultiple: :queue_position_multiple,
        queuePositionDynamicMultiple: :queue_position_dynamic_multiple,
        ignoreQuota: :ignore_quota,
        cancelQuota: :cancel_quota,
        mercyPeriodInSec: :mercy_period_in_sec,
        paxCancelRecordTTLInSec: :pax_cancel_record_ttl_in_sec,
        remindSnoozeTimeInSec: :remind_snooze_time_in_sec,
        remindBeforeInSec: :remind_before_in_sec,
    }
  }

  def pretty_print_data
    JSON.pretty_generate(JSON.parse(data))
  end

  after_initialize :default_values
  def default_values
    self.cancel_quota ||= 0
    self.inbox_and_push_ttl_in_minute ||= 1
    if self.rank_template == ''
      self.rank_template = '%s:%s '
    end
  end

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


  def generate_uid_and_version
    if uid.present?
      max_version = max_version_of(uid)
      self.version = (max_version&.version || -1) + 1
      return
    end

    self.uid = SecureRandom.base64(9).gsub('/', 'S')
    self.version = 0

  end

  def save(*)
    self.data = serialize_to_compact_json
    if self.data == max_version_of(uid)&.data
      # No need save
      self.version = max_version_of(uid).version
      return true
    end
    generate_uid_and_version
    super
  end

  # Construct config object from JSON
  def deserialize_from_json(str)
    raw_hash = JSON.parse(str)
    walk_key_map_reverse(JSON_KEY_MAP, ActiveSupport::HashWithIndifferentAccess.new(raw_hash))
    self
  end

  def value_from_user_input(attr)
    OrbitalConfig.type_for_attribute(attr.to_s).deserialize(send(attr))
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

  def geohashes_should_not_contain_invalid_chars
    # validates :pickup_area_geo, :bay_area_geo, format: { with: /\A[0-9a-zA-Z\d\s]+\z/i, message: '' }
    str = 'only allows digits and letters, quotes and other characters are not allowed'
    regex = /\A(\s*,?[0-9a-zA-Z\d]+\s*,?\s*)+\z/i
    v = value_from_user_input(:pickup_area_geo)
    if v.present? && !v.match(regex)
      errors.add(:pickup_area_geo, str)
    end

    v = value_from_user_input(:bay_area_geo)
    if v.present? && !v.match(regex)
      errors.add(:bay_area_geo, str)
    end
  end

  def vehicle_type_and_names_format
    return if !vehicle_type_names || vehicle_type_names.is_a?(Hash)
    begin
      JSON.parse(value_from_user_input(:vehicle_type_names))
    rescue Exception => e
      errors.add(:vehicle_type_names, 'is invalid, JSON parsing error: ' + e.to_s)
    end

    if !vehicle_type_names.is_a?(Hash) && errors[:vehicle_type_names].empty?
      errors.add(:vehicle_type_names, 'is invalid, must be in the format of "vehicle type id": "Name"')
    end
  end


  def queue_position_dynamic_multiple_format
    return if !queue_position_dynamic_multiple
    return if queue_position_dynamic_multiple.is_a?(Hash) && queue_position_dynamic_multiple.empty?

    if !queue_position_dynamic_multiple.is_a?(Hash)
      begin
        JSON.parse(value_from_user_input(:queue_position_dynamic_multiple))
      rescue Exception => e
        errors.add(:queue_position_dynamic_multiple, 'is invalid, JSON parsing error: ' + e.to_s)
      end
    end

    if errors[:queue_position_dynamic_multiple].empty?
      if !queue_position_dynamic_multiple.is_a?(Hash) || !queue_position_dynamic_multiple.first[1].is_a?(Integer)
          errors.add(:queue_position_dynamic_multiple, 'is invalid, must be in the format of "number": number')
      end
    end
  end

  def max_version_of(uid)
    @max_version ||= OrbitalConfig.where(uid: uid).order(version: :asc).last
  end
end

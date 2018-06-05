module ConfigHelper
  def display_value_for(attr)
    OrbitalConfig.type_for_attribute(attr.to_s).deserialize(@config.send(attr))
  end
end

module ConfigHelper
  def display_value_for(attr)
    OrbitalConfig.type_for_attribute(attr.to_s).deserialize(@config.send(attr))
  end

  def config_pretty_display_url(config)
    if !config.version || config.version == 0
      config_url(config.uid)
    else
      config_version_url(config.uid, config.version)
    end
  end
end

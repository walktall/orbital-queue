class ConfigController < ApplicationController
  def new
    @config = OrbitalConfig.new
    if params[:config] && valid_json?(params[:config][:json])
      @config.deserialize_from_json(params[:config][:json])
    end
  end

  def create
    @config = OrbitalConfig.new(params.require(:json_config).permit!)

    if @config.valid?
      redirect_to config_path(id: 0, config: @config.serialize_to_compact_json), notice: 'Config generated successfully:'
    else
      render 'new'
    end
  end

  def show
    if params[:config]
      @config = OrbitalConfig.new
      @config.deserialize_from_json(params[:config])
    end
  end

  private

  def valid_json?(json)
    !!JSON.parse(json)
  rescue JSON::ParserError => _e
    false
  end
end

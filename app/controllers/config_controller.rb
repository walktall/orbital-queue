class ConfigController < ApplicationController
  include ConfigHelper

  def new
    @config = OrbitalConfig.new
    if params[:config] && valid_json?(params[:config][:json])
      @config.deserialize_from_json(params[:config][:json])
    end
  end

  def edit
    @config = load_config
  end

  def create
    @config = OrbitalConfig.new(params.require(:orbital_config).permit!)

    if @config.save
      redirect_to config_pretty_display_url(@config), notice: 'Config generated successfully:'
    else
      render 'new'
    end
  end

  def restore
  end

  def show
    @config = load_config
  end

  private

  def valid_json?(json)
    !!JSON.parse(json)
  rescue JSON::ParserError => _e
    false
  end

  def load_config
    @config = OrbitalConfig.find_by!(uid: params[:uid], version: (params[:version] || 0))
    @config.deserialize_from_json(@config.data)
    @config
  end
end

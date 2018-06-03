class ConfigController < ApplicationController
  def new
    @config = JsonConfig.new
    if params[:restore_from]
      @config.deserialize_from_json(params[:restore_from])
    end
  end

  def create
    @config = JsonConfig.new(params.require(:json_config).permit!)
    flash.now[:notice] = 'Config generated successfully:'
  end

  def show
  end
end

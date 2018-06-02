class ConfigController < ApplicationController
  def new
    @config = JsonConfig.new
  end

  def create
    @config = JsonConfig.new(params.require(:json_config).permit!)
    flash[:notice] = 'Config generated successfully:'
  end

  def show
  end
end

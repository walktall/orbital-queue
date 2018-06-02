class ConfigController < ApplicationController
  def new
    @config = JsonConfig.new
  end

  def create
    byebug
    @config = JsonConfig.new(params.require(:json_config).permit!)
    render 'new'
  end

  def show
  end
end

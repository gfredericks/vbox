class DrivesController < ApplicationController
  def create
    Drive.create(params[:name])
    redirect_to machines_url
  end
end

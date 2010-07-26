class DrivesController < ApplicationController
  def create
    if(params[:machine_id])
      d = Drive.find(params[:uuid])
      m = Machine.find(params[:machine_id])
      report m.connect_drive(d)
    else
      report Drive.create(params[:name])
    end
    redirect_to machines_url
  end
end

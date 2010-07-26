class DrivesController < ApplicationController
  def create
    if(params[:machine_id])
      d = Drive.find(params[:uuid])
      m = Machine.find(params[:machine_id])
      report m.connect_drive(d)
    else
      report Drive.create(params[:name])
    end
    redirect_to_index
  end

  def destroy
    if(params[:machine_id])
      # This means eject from the machine, not destroy the drive
      m = Machine.find(params[:machine_id])
      report m.disconnect_drive
    end
    redirect_to_index
  end
end

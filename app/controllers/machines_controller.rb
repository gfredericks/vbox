class MachinesController < ApplicationController
  def index
    @machines = Machine.all
    @drives = Drive.bases
    @isos = ISO.all
  end

  def start
    @machine = Machine.find(params[:id])
    report @machine.start(params[:vrdp_port])
    redirect_to_index
  end

  def stop
    @machine = Machine.find(params[:id])
    report @machine.stop
    redirect_to_index
  end

  def create
    unless Machine.find(params[:name])
      report Machine.create(params[:name])
    end
    redirect_to_index
  end
end

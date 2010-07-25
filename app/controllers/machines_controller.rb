class MachinesController < ApplicationController
  def index
    @machines = Machine.all
    @drives = Drive.bases
  end

  def start
    @machine = Machine.find(params[:id])
    @machine.start
    redirect_to(machines_url)
  end

  def stop
    @machine = Machine.find(params[:id])
    @machine.stop
    redirect_to(machines_url)
  end

  def create
    unless Machine.find(params[:name])
      Machine.create(params[:name])
    end
    redirect_to machines_url
  end
end

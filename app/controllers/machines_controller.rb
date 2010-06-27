class MachinesController < ApplicationController
  def index
    @machines = Machine.all
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
end

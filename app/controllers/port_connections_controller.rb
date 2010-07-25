class PortConnectionsController < ApplicationController
  def create
    m = Machine.find(params[:machine_id])
    m.create_port_connection(params[:host],params[:guest],params[:name])
    redirect_to_index
  end

  def destroy
    m = Machine.find(params[:machine_id])
    m.destroy_port_connection(params[:id])
    redirect_to_index
  end
end

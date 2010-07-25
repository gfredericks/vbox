class IsoController < ApplicationController
  def create
    m = Machine.find(params[:machine_id])
    m.connect_iso(ISO.find(params[:name]))
  end
end

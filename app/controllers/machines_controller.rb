class MachinesController < ApplicationController
  def index
    @machines = Machine.all
  end
end

class MachinesController < ApplicationController
  def index
    @machines = Machine.all
    Rails.logger.error("What is machines?")
  end
end

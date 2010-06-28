class SnapshotsController < ApplicationController
  def create
    machine = Machine.find(params[:machine_id])
    if(machine)
      `VBoxManage snapshot #{machine.name} take '#{params[:name].gsub("\\","\\\\").gsub("'","\\'")}'`
    else
      flash[:notice] = "There is no machine called #{params[:machine_id]}"
    end
    redirect_to_index
  end

  def destroy
    machine = Machine.find(params[:machine_id])
    snapshot = Snapshot.find(machine, params[:id])
    if(machine and snapshot)
      `VBoxManage snapshot #{machine.name} delete #{snapshot.uuid}`
    else
      flash[:notice] = "Cannot find snapshot with uuid=#{params[:id]}"
    end
    redirect_to_index
  end

  def restore
    machine = Machine.find(params[:machine_id])
    snapshot = Snapshot.find(machine, params[:id])
    if(machine and snapshot)
      `VBoxManage snapshot #{machine.name} restore #{snapshot.uuid}`
    else
      flash[:notice] = "Cannot find snapshot with uuid=#{params[:id]}"
    end
    redirect_to_index
  end
end

class Drive
  attr_reader :uuid, :type, :parent, :machine_name, :snapshot_id
  def Drive.all
    `VBoxManage list hdds`.split("\n\n")[1..-1].map do |lines|
      get = lambda{|what|lines.match(/^#{what}:\s+(.*)$/)[1] rescue nil}
      uuid = get.call("UUID")
      parent = get.call("Parent UUID")
      type = get.call("Type")
      machine_name = get.call("Usage").match(/^(.*?)\s+\(UUID: /)[1] rescue nil
      snapshot_id = get.call("Usage").match(/\[.*\(UUID: ([-\da-f]+)\)\]/)[1] rescue nil
      Drive.new(uuid,type,parent,machine_name,snapshot_id)
    end
  end

  def Drive.find(uuid)
    Drive.all.find{|d|d.uuid==uuid}
  end

  def Drive.bases
    Drive.all.select{|d|d.parent=="base"}
  end

  def Drive.create(name,size=20000)
    #`VBoxManage createhd --filename /home/#{ENV['User']}/.VirtualBox/HardDisks/#{name}.vdi --size #{size} --variant Standard --remember`
    `VBoxManage createhd --filename #{name}.vdi --size #{size} --remember`
  end

  def children
    Drive.all.select{|d|d.parent == @uuid}
  end
  private 
  def initialize(uuid,type,parent,machine_name,snapshot_id)
    @uuid=uuid
    @type=type
    @parent=parent
    @machine_name=machine_name
    @snapshot_id=snapshot_id
  end
end

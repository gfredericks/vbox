class Machine
  attr_accessor :name, :info, :ports, :snapshots, :uuid

  def refresh
    vminfo = `VBoxManage showvminfo '#{@name}'`
    re = /^\s*([^:]+?)\s*:\s*(.*?)\s*$/
    info = vminfo.split("\n").select{|line|line=~re}
    info = info.map do |line|
      line =~ re
      {$1 => $2}
    end
    @info = info.inject({}){|u,v|u.merge(v)}
    @uuid = @info["UUID"]
    @state = @info["State"]
    @ports = @info.keys.select{|k|k=~/NIC 1 Rule\(\d+\)/}.map do |rule|
      @info[rule] =~ /name = (\w+),.*host port = (\d+),.*guest port = (\d+)/
      {:name => $1, :host => $2.to_i, :guest => $3.to_i}
    end
    if(k=vminfo.index("Snapshots:"))
      @snapshots = Snapshot.parse(vminfo[(k+11)..-1].split("\n"))
    else
      @snapshots=[]
    end
  end

  def stop
    return false unless(running?)
    `VBoxManage controlvm #{name} poweroff`
    true
  end

  def start
    return false if(running?)
    job = fork do
      exec "VBoxHeadless -s #{name} --vrdp=off"
    end
    Process.detach(job)
    true
  end

  def running?
    @state =~ /^running/
  end

  def Machine.all
    all = `VBoxManage list vms`
    all.scan(/"[^"]+"/).map{|s|Machine.new(s[1...-1])}
  end

  def Machine.find(name)
    Machine.all.select{|m|m.name==name}.first
  end

  def Machine.create(name)
    puts `VBoxManage createvm --name #{name.inspect} --register`
    m = Machine.find(name)
    puts `VBoxManage storagectl #{m.uuid} --name 'IDE Controller' --controller PIIX4 --add ide`
    puts `VBoxManage storagectl #{m.uuid} --name 'DVD' --add ide`
  end

  def destroy
    `VBoxManage unregistervm #{@uuid} --delete`
  end

  def to_param
    name
  end

  def connect_drive(d)
    `VBoxManage storageattach #{@uuid} --storagectl 'IDE Controller' --port 0 --device 0 --type hdd --medium #{d.uuid}`
  end

  def disconnect_drive
    `VBoxManage storageattach #{@uuid} --storagectl 'IDE Controller' --port 0 --device 0 --forceunmount --medium none`
  end

  def connect_iso(iso)
    `VBoxManage storageattach #{@uuid} --storagectl 'DVD' --port 0 --device 0 --forceunmount --type dvddrive --medium "#{iso.filepath}"`
  end

  private

  def initialize(name)
    @name=name
    refresh
  end
end

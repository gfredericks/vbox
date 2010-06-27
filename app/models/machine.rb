class Machine
  attr_accessor :name, :info, :ports, :snapshots

  def refresh
    vminfo = `VBoxManage showvminfo '#{name}'`
    re = /^\s*([^:]+?)\s*:\s*(.*?)\s*$/
    info = vminfo.split("\n").select{|line|line=~re}
    info = info.map do |line|
      line =~ re
      {$1 => $2}
    end
    @info = info.inject({}){|u,v|u.merge(v)}
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

  def to_param
    name
  end

  private

  def initialize(name)
    @name=name
    refresh
  end
end

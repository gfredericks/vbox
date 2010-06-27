class Machine
  attr_accessor :name, :info
  def initialize(name)
    @name=name
    refresh
  end

  def refresh
    info = `VBoxManage showvminfo '#{name}'`
    re = /^\s*([^:]+?)\s*:\s*(.*?)\s*$/
    info = info.split("\n").select{|line|line=~re}
    info = info.map do |line|
      line =~ re
      {$1 => $2}
    end
    @info = info.inject({}){|u,v|u.merge(v)}
    @state = @info["State"]
  end

  def stop
    :stub
  end

  def start
    :stub
  end

  def running?
    @state =~ /^running/
  end

  def Machine.all
    all = `VBoxManage list vms`
    all.scan(/"[^"]+"/).map{|s|Machine.new(s[1...-1])}
  end
end

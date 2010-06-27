class Machine
  def initialize(name)
    @name=name
    info = `VBoxManage showvminfo '#{name}'`
    re = /^\s*([^:]+?)\s*:\s*(.*?)\s*$/
    info = info.split("\n").select{|line|line=~re}
    info = info.map do |line|
      line =~ re
      {$1 => $2}
    end
    @info = info.inject({}){|u,v|u.merge(v)}
  end

  def Machine.all
    all = `VBoxManage list vms`
    all.scan(/"[^"]+"/).map{|s|Machine.new(s[1...-1])}
  end
end

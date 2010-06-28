class Snapshot
  attr_reader :name, :uuid, :current, :children
  def Snapshot.parse(lines)
    lines = lines.select{|l|l=~/^\s*Name:/}
    indent = lambda do |line|
      line.match(/^(\s*)\S/)[1].length
    end
    parseit = lambda do |some_lines|
      return [] if some_lines.empty?
      level = indent.call(some_lines[0])
      m = some_lines[0].match(/Name: (.*?) \(UUID: ([-\da-f]+)\)( \*)?/)
      uuid = m[2]
      name = m[1]
      current = (!!m[3])
      if(some_lines.length > 1)        
        start,finish=1,0
        finish += 1 while(finish+1<some_lines.length and indent.call(some_lines[finish+1]) > level)
        child_lines = some_lines[start..finish]
        children = parseit.call(child_lines)
        return [Snapshot.new(uuid,name,current,children)]+parseit.call(some_lines[(finish+1)..-1])
      else
        return [Snapshot.new(uuid,name,current,[])]
      end
    end
    parseit.call(lines)
  end

  def deletable?
    # This is virtualbox's rule
    children.length < 2
  end

  def Snapshot.find(machine,uuid)
    machine.refresh
    look_for = lambda do |snapshot|
      return snapshot if(snapshot.uuid == uuid)
      ss = snapshot.children.map{|c|look_for.call(c)}.select{|c|c}
      return ss[0] unless ss.empty?
    end
    machine.snapshots.map{|ss|look_for.call(ss)}.select{|ss|ss}.first
  end
   
  def to_param
    self.uuid
  end

  private
  def initialize(uuid,name,current,children)
    @uuid=uuid
    @name=name
    @current=current
    @children=children
  end
end

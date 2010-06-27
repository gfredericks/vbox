class Snapshot
  attr_reader :name, :uuid, :children
  def Snapshot.parse(lines)
    lines = lines.select{|l|l=~/^\s*Name:/}
    indent = lambda do |line|
      line.match(/^(\s*)\S/)[1].length
    end
    parseit = lambda do |some_lines|
      return [] if some_lines.empty?
      level = indent.call(some_lines[0])
      m = some_lines[0].match(/Name: (.*?) \(UUID: ([-\da-f]+)\)/)
      uuid = m[2]
      name = m[1]
      if(some_lines.length > 1)        
        start,finish=1,0
        finish += 1 while(finish+1<some_lines.length and indent.call(some_lines[finish+1]) > level)
        child_lines = some_lines[start..finish]
        children = parseit.call(child_lines)
        return [Snapshot.new(uuid,name,children)]+parseit.call(some_lines[(finish+1)..-1])
      else
        return [Snapshot.new(uuid,name,[])]
      end
    end
    parseit.call(lines)
  end

  private
  def initialize(uuid,name,children)
    @uuid=uuid
    @name=name
    @children=children
  end
end

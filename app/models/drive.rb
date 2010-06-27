class Drive
  def Drive.all
    `VBoxManage list hdds`.split("\n").map{|l|l.match /^UUID:\s+([-0-9a-f]+)$/}.select{|x|x}.map{|x|Drive.new(x[1])}
  end
  private 
  def initialize(uuid)
    @uuid=uuid
  end
end

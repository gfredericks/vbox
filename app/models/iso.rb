require 'ftools'

class ISO
  BASE_DIR = "/home/#{ENV['USER']}/.VirtualBox/ISOs"
  File.makedirs(BASE_DIR)
  attr_reader :filename

  def ISO.all
    Dir.entries(BASE_DIR).select{|e|e=~/\.iso$/}.map{|e|ISO.new e}
  end

  def ISO.find(filename)
    ISO.all.select{|iso|iso.filename==filename}
  end

  def filepath
    BASE_DIR + "/" + @filename
  end

  private
  def initialize(filename)
    @filename=filename
  end
end

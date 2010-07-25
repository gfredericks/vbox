require 'ftools'

class ISO
  BASE_DIR = "/home/#{ENV['USER']}/.VirtualBox/ISOs"
  File.makedirs(BASE_DIR)

  def ISO.all
    Dir.entries(BASE_DIR).select{|e|e=~/\.iso$/}
  end
end

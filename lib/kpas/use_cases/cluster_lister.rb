require "pathname"
require_relative '../cli'

class ClusterLister
  def call
    cluster_path = ::CLI.cluster_path
    config_folders = Pathname.new(cluster_path).children.select { |c| c.directory? }
    config_folders.each {|folder| puts File.basename(folder) }
  end
end
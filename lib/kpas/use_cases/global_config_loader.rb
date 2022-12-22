require 'yaml'
require_relative './global_config_generator'

class GlobalConfigLoader
  def initialize(config_path, create: true)
    @config_path = config_path
    @create = create
  end

  def call
    if exists?
      YAML.load(File.read(config_path))
    elsif create
      ::GlobalConfigGenerator.new(config_path).call
    end
  end

  private

  attr_reader :config_path, :create

  def exists?
    File.exists?(config_path)
  end
end
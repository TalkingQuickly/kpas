require_relative './use_cases/global_config_generator'
require_relative './cli'
require 'fileutils'

class Config < Thor

  desc 'generate', 'Generate a new global config file'
  def generate
    config_path = ::CLI.global_config_path

    if !File.exists?(config_path) || ask('Overwrite existing config file?', limited_to: ['yes', 'no']) == 'yes'
      ::GlobalConfigGenerator.new(config_path).call(force: true)
    end
  end

  desc 'config edit', 'Edit an existing global config using the editor defined by $EDITOR'
  def edit 
    system('$EDITOR ~/.kpas/config.yaml')
  end
end
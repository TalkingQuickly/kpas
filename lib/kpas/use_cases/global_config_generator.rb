require 'fileutils'

class GlobalConfigGenerator
  def initialize(config_path)
    @config_path = config_path
  end

  def call(force: false)
    return unless force || !File.exists?(config_path)

    FileUtils.mkdir_p(File.dirname(config_path))

    File.open(config_path, 'w') do |file|
      file.write(default_config.to_yaml)
    end

    default_config
  end

  private

  attr_reader :config_path

  def default_config
    {
      dns_cloudflare: {
        api_token: "NOTSET",
        zone: "NOTSET"
      }
    }
  end
end
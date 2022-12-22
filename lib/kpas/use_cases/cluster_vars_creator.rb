require 'erb'
require 'securerandom'
require 'fileutils'
require 'json'
require_relative './cluster_path_facts'

class ClusterVarsCreator
  def initialize(options)
    @options = options
  end

  def create(name, provider)
    set_path_facts(::ClusterPathFacts.new(name, CLI.cluster_path))
    providers_path = File.join(CLI.cli_path, 'providers')
    shared_templates_path = File.join(CLI.cli_path, 'templates')
    provider_class = Object.const_get("::Providers::#{provider.split('_').collect(&:capitalize).join}")

    FileUtils.mkdir_p(path_facts.cluster_config_path)

    FileUtils.mkdir_p(path_facts.inventory_directory)

    write_file(path_facts.vault_password_path, options[:password])

    render_template_to_file(
      File.join(providers_path, provider, 'templates', 'provider_values.yml.erb'),
      path_facts.provider_values_path
    )

    render_template_to_file(
      File.join(providers_path, provider, 'templates', 'provider_secrets.yml.erb'),
      path_facts.provider_vault_path,
      encrypt: true,
      vault_password_path: path_facts.vault_password_path
    )

    render_template_to_file(
      File.join(shared_templates_path, 'cluster_shared_values.yml.erb'),
      path_facts.shared_values_path
    )

    render_template_to_file(
      File.join(shared_templates_path, 'cluster_shared_secrets.yml.erb'),
      path_facts.shared_vault_path,
      encrypt: true,
      vault_password_path: path_facts.vault_password_path
    )

    render_template_to_file(
      File.join(providers_path, provider, 'templates', 'inventory.yml.erb'),
      path_facts.inventory_path(provider_class.inventory_filename)
    )

    FileUtils.cp(
      File.join(shared_templates_path, 'vault_password_file.sh'),
      path_facts.vault_password_file_path
    )

    File.delete(path_facts.vault_password_path)
  end

  private

  attr_reader :options, :path_facts

  def set_path_facts(path_facts)
    @path_facts = path_facts
  end

  def render_template_to_file(template_path, output_path, encrypt: false, vault_password_path: nil)
    data = render_template(template_path)
    write_file(output_path, data)
    return unless encrypt
    system("ansible-vault encrypt #{output_path} --vault-password-file #{vault_password_path} --output #{output_path}")
  end

  def render_template(path)
    ERB.new(File.read(path)).result(binding)
  end

  def write_file(path, contents)
    File.open(path, 'w') { |file| file.write(contents) }
  end
end
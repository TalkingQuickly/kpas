require 'yaml'
require 'ansible/vault'

class ConfigParser
  def initialize(path_facts, vault_password: nil)
    @path_facts = path_facts
    @vault_password = vault_password
  end

  def cluster_provider
    @cluster_provider ||= parsed_shared_config_file['global_cluster']['kpas_provider']
  end

  def cluster_provider_class
    @cluster_provider_class ||= Object.const_get("::Providers::#{cluster_provider.split('_').collect(&:capitalize).join}")
  end

  def kubectl_path
    @kubectl_path ||= path_facts.master_kubeconf_path
  end

  def cluster_playbook
    cluster_provider_class.cluster_playbook(parsed_shared_config_file)
  end

  def cluster_env_vars
    cluster_provider_class.cluster_env_vars(parsed_provider_vault_file)
  end

  def parsed_shared_config_file
    @parsed_config_file ||= YAML.load_file(path_facts.shared_values_path)
  end

  def parsed_provider_vault_file
    decrypt_vault_file(path_facts.provider_vault_path)
  end

  private

  attr_reader :path_facts, :vault_password

  def decrypt_vault_file(path)
    YAML.load(Ansible::Vault.read(path: path, password: vault_password))
  end
end
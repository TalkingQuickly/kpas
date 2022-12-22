require_relative '../cli'
require_relative './cluster_path_facts'
require_relative './config_parser'

class Deleter
  def initialize(cluster_name, vault_password)
    @cluster_name = cluster_name
    @vault_password = vault_password
  end

  attr_reader :cluster_name, :vault_password

  def call
    path_facts = ::ClusterPathFacts.new(cluster_name, ::CLI.cluster_path)
    config = ::ConfigParser.new(path_facts, vault_password: vault_password)
    ansible_path = File.join(::CLI.ansible_path, "#{config.cluster_playbook}.yml")

    system("ANSIBLE_HASH_BEHAVIOUR=merge VAULT_PASSWORD=#{vault_password} #{config.cluster_env_vars} ansible-playbook \
      -i #{path_facts.inventory_path(config.cluster_provider_class.inventory_filename)} #{ansible_path} \
      --extra-vars \"@#{path_facts.provider_values_path}\" \
      --extra-vars \"@#{path_facts.shared_values_path}\" \
      --extra-vars \"@#{path_facts.provider_vault_path}\" \
      --extra-vars \"@#{path_facts.shared_vault_path}\" \
      --extra-vars \"{'global_cluster':{'state':'absent'}}\" \
      --extra-vars \"{'skip_provision':false}\" \
      --vault-password-file \"#{path_facts.vault_password_file_path}\"")
  end
end
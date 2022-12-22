require_relative './use_cases/provisioner'
require_relative './use_cases/deleter'
require_relative './direnv'
require_relative './cli'
require_relative './use_cases/cluster_lister'

class Cluster < Thor
  class_option :password, desc: "The password that will be used to decrypt secrets"

  desc 'direnv', 'Operations for generating and working with direnv files'
  subcommand 'direnv', ::DirEnv

  desc 'provision CLUSTER_NAME', 'Create infrastructure (e.g. VM\'s / Node Groups etc) for a cluster'
  option 'skip_infra', desc: 'Whether to skip the step of creating underlying infrastructure, e.g. assume the cluster already exists and just install cluster apps', type: :boolean, default: false
  def provision(cluster_name)
    vault_password = options[:password] || ask("Vault Password:", echo: false)
    ::Provisioner.new(cluster_name, vault_password, skip_infra: options[:skip_infra]).call
  end

  desc 'delete CLUSTER_NAME', 'Delete cluster (e.g. VM\'s / Node Groups etc) for a cluster'
  def delete(cluster_name)
    vault_password = options[:password] || ask("Vault Password:", echo: false)
    if ask("To continue deleting this cluster, enter the cluster name (#{cluster_name})") == cluster_name
      ::Deleter.new(cluster_name, vault_password).call
    end
  end

  desc "show_secrets CLUSTER_NAME TYPE", "Outputs the cluster secrets to STDOUT where TYPE is one of provider,shared"
  def show_secrets(cluster_name, type)
    vault_password = options[:password] || ask("Vault Password:", echo: false)
    path_facts = ::ClusterPathFacts.new(cluster_name, ::CLI.cluster_path)

    file = type == 'provider' ? path_facts.provider_vault_path : path_facts.shared_vault_path
    system("VAULT_PASSWORD=#{vault_password} ansible-vault view #{file} --vault-password-file \"#{path_facts.vault_password_file_path}\"")
  end

  desc "list", "Prints out a list of available clusters"
  def list
    ::ClusterLister.new.call
  end
end
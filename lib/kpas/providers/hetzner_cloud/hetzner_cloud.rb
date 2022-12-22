require_relative "../provider"
require_relative '../../cli'
require_relative '../../use_cases/cluster_vars_creator'

module Providers
  class HetznerCloud < Provider
    class_option :api_token, desc: "The Hetzner Cloud API token to be used to create VM's"
    class_option :ssh_key_name, desc: "The name of the Hetzner Cloud SSH Key that will be used to access the VM's"

    desc "generate CLUSTER_NAME", "Generate the config files for a hetzner cloud cluster"
    def generate(cluster_name)
      new_options = ask_if_needed(options)
      new_options[:cluster_name] = cluster_name
      new_options[:cluster_provider] = 'hetzner_cloud'
      ::ClusterVarsCreator.new(new_options).create(cluster_name, 'hetzner_cloud')
      new_options
    end

    desc "bootstrap CLUSTER_NAME", "Generate the config files for a hetzner cloud cluster and start the creation process"
    def bootstrap(cluster_name)
      options = generate(cluster_name)
      ::Provisioner.new(cluster_name, options[:password]).call
    end

    no_commands do
      def self.cluster_playbook(shared_config)
        shared_config['global_cluster']['kpas_variant'] == 'k8s' ? 'k8s-hetzner-cloud-cluster' : 'k3s-hetzner-cloud-cluster'
      end

      def self.cluster_env_vars(provider_vault)
        "HCLOUD_TOKEN=#{provider_vault['vault_global_hetzner_api_token']}"
      end

      def self.inventory_filename
        'inventory.hcloud.yml'
      end

      def ask_if_needed(options)
        options = super(options)
        unless options[:api_token] && options[:ssh_key_name]
          options[:api_token] ||= ask('Your Hetzner API token: ')
          options[:ssh_key_name] ||= ask('The name of the SSH Key in your hetzner account: ')
        end

        options
      end
    end
  end
end
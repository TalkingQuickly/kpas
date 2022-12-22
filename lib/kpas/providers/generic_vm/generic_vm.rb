require_relative "../provider"
require_relative '../../cli'
require_relative '../../use_cases/cluster_vars_creator'

module Providers
  class GenericVm < Provider
    desc "generate CLUSTER_NAME", "Generate the config files for a generic VM based cluster"
    def generate(cluster_name)
      new_options = ask_if_needed(options)
      new_options[:cluster_name] = cluster_name
      new_options[:cluster_provider] = 'generic_vm'
      ::ClusterVarsCreator.new(new_options).create(cluster_name, 'generic_vm')
      new_options
    end

    desc "bootstrap CLUSTER_NAME", "Generate the config files for a generic VM based cluster and start the creation process"
    def bootstrap(cluster_name)
      options = generate(cluster_name)
      ::Provisioner.new(cluster_name, options[:password]).call
    end

    no_commands do
      def self.cluster_playbook(shared_config)
        'generic-vm-k3s-single-master'
      end

      def self.cluster_env_vars(provider_vault)
        ""
      end

      def self.inventory_filename
        'inventory.yml'
      end

      def ask_if_needed(options)
        options = super(options)
        unless options[:master_ip] && options[:ssh_user]
          options[:master_ip] ||= ask('The IP of the master: ')
          options[:ssh_user] ||= ask('The SSH user to provision with: ')
        end

        options
      end
    end
  end
end
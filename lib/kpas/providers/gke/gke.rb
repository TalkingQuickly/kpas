require_relative "../provider"
require_relative '../../cli'
require_relative '../../use_cases/cluster_vars_creator'

module Providers
  class Gke < Provider
    class_option :gke_service_account_path, desc: "The full path (~ will not be expanded) to the service account file containing the relevant GKE credentials"
    class_option :gke_project, desc: "The name of the GKE project the cluster should be created in"
    class_option :gke_region, desc: "The GKE region the project should be created in"

    desc "generate CLUSTER_NAME", "Generate the config files for a GKE cluster"
    def generate(cluster_name)
      check_dependencies

      new_options = ask_if_needed(options)
      new_options[:cluster_name] = cluster_name
      new_options[:cluster_provider] = 'gke'
      new_options[:gke_service_account_content] = serialize_service_account(options[:gke_service_account_path])
      ::ClusterVarsCreator.new(new_options).create(cluster_name, 'gke')
      new_options
    end

    desc "bootstrap CLUSTER_NAME", "Generate the config files for a GKE and start the creation process"
    def bootstrap(cluster_name)
      options = generate(cluster_name)
      ::Provisioner.new(cluster_name, options[:password]).call
    end

    no_commands do
      def self.cluster_playbook(shared_config)
        'gke_cluster'
      end

      def self.cluster_env_vars(provider_vault)
        "HCLOUD_TOKEN=#{provider_vault['vault_global_hetzner_api_token']}"
      end

      def self.inventory_filename
        nil
      end

      def ask_if_needed(options)
        options = super(options)
        return options if options[:gke_service_account_path] && options[:gke_project] && options[:gke_region]

        options[:gke_service_account_path] ||= ask('Path to GKE service account file: ')
        options[:gke_project] ||= ask('GKE project Name: ')
        options[:gke_region] ||= ask('GKE region')

        options
      end

      def serialize_service_account(path)
        service_account = File.read(path)
        decoded_json = JSON.parse(service_account)
        decoded_json.to_json
      end

      def check_dependencies
        super
        system('python -c "import google.auth"') || raise('Python module google-auth is missing')
        system('python -c "import requests"') || raise('Python module requests is missing')
      end
    end
  end
end
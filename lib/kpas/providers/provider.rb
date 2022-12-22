require_relative '../cli'
require_relative '../use_cases/global_config_loader'

module Providers
  class Provider < Thor
    class_option :password, desc: "The password that will be used to encrypt secrets"
    class_option :base_domain, desc: "The base domain for the cluster which will have a wildcard DNS entry at *.base_domain pointing at the clusters public ingress"
    class_option :variant, desc: "The Kubernetes variant (k8s or k3s)", default: 'k8s'
    class_option :k3s_multimaster, desc: 'If using K3S, should this be a multimaster configuration', type: :boolean, default: false
    class_option :letsencrypt_production, desc: 'Whether to use the production LetsEncrypt, if not set, the testing server will be used', type: :boolean, default: false
    class_option :acme_email, desc: 'The email address to use for Lets Encrypt certificates'

    class_option :dns_cloudflare, desc: 'Whether or not to use Cloudflare for DNS', default: false, type: :boolean
    class_option :dns_cloudflare_api_token, desc: "The Cloudflare API token if cloudflare is being used for automatic DNS entry creation"
    class_option :dns_cloudflare_zone, desc: "The Cloudflare zone if cloudflare is being used for automatic DNS entry creation"

    no_commands do
      def self.cluster_playbook
        raise 'AbstractMethod'
      end

      def self.cluster_env_vars
        raise 'AbstractMethod'
      end

      def self.inventory_filename
        'inventory.yml'
      end

      def ask_if_needed(options)
        options = Thor::CoreExt::HashWithIndifferentAccess.new.merge(options)
        options[:global_config] = GlobalConfigLoader.new(::CLI.global_config_path).call
        unless options[:password]
          password = ask("What password should be used to encrypt secrets", echo: false)
          password_confirmation = ask("\nPlease confirm the password", echo: false)
          exit(0) unless password == password_confirmation
          options[:password] = password
        end

        options[:base_domain] ||= ask("\nWhat is the base domain?")
        options[:acme_email] ||=  ask("\nWhat email should be used for acme certificates?")

        if options[:dns_cloudflare]
          options[:dns_cloudflare_api_token] = ask('Your Cloudflare API token:', default: options[:global_config][:dns_cloudflare][:api_token])
          options[:dns_cloudflare_zone] = ask('The Cloudflare zone entries should be created in:',  default: options[:global_config][:dns_cloudflare][:zone])
        end

        options
      end

      def check_dependencies
        system('which ansible > /dev/null') || raise('Ansible not found')
        system('which ansible-vault > /dev/null') || raise('Ansible vault not found')
      end
    end
  end
end
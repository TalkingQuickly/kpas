require_relative './providers/hetzner_cloud/hetzner_cloud'
require_relative './providers/gke/gke'
require_relative './providers/generic_vm/generic_vm'
require_relative './cluster'
require_relative './config'

class CLI < Thor
  CLUSTER_PATH = File.join(Dir.home, '.kpas')

  desc 'hetzner_cloud', 'Operations for generating and bootstrapping Hetzner Cloud based clusters'
  subcommand 'hetzner_cloud', ::Providers::HetznerCloud 

  desc 'gke', 'Operations for generating and bootstrapping GKE based clusters'
  subcommand 'gke', ::Providers::Gke

  desc 'generic_vm', 'Operations for generating and bootstrapping cluster based on generic existing VM\'s'
  subcommand 'generic_vm', ::Providers::GenericVm

  desc 'cluster', 'Operations for manipulating an existing KPAS cluster'
  subcommand 'cluster', ::Cluster

  desc 'config', 'Operations for manipulating global KPAS configuration'
  subcommand 'config', ::Config

  no_commands do 
    def self.exit_on_failure?
      true
    end

    def self.cluster_path
      CLUSTER_PATH
    end

    def self.global_config_path
      File.join(self.cluster_path, 'config.yaml')
    end

    def self.cli_path
      File.dirname(File.absolute_path(__FILE__))
    end

    def self.resources_path
      File.expand_path(File.join(self.cli_path, '..', '..','resources'))
    end

    def self.ansible_path
      File.join(self.resources_path, 'ansible')
    end
  end
end
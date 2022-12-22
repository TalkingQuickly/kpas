require_relative './use_cases/dir_env_manager'
require_relative './use_cases/cluster_path_facts'
require_relative './cli'

class DirEnv < Thor

  desc 'generate CLUSTER_NAME', 'Generate and allow a direnv .envrc for the given cluster'
  def generate(cluster_name)
    cluster_path_facts = ::ClusterPathFacts.new(cluster_name, CLI.cluster_path)
    ::DirEnvManager.new(cluster_path_facts, Dir.pwd).create_dir_env_file
  end
end
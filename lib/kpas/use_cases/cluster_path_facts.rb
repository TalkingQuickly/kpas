class ClusterPathFacts
  def initialize(cluster_name, base_path)
    @cluster_name = cluster_name
    @base_path = base_path
  end

  attr_reader :cluster_name, :base_path

  def exists?
    File.directory?(cluster_config_path)
  end

  def vault_password_path
    @vault_password_path ||= File.join(cluster_config_path, 'vault_password')
  end

  def vault_password_file_path
    @vault_password_file_path ||= File.join(cluster_config_path, 'vault_password_file.sh')
  end

  def provider_values_path
    @provider_values_path ||= File.join(cluster_config_path, 'provider_values.yml')
  end

  def provider_vault_path
    @provider_vault_path ||= File.join(cluster_config_path, 'provider_vault.yml')
  end
  
  def shared_values_path
    @shared_values_path ||= File.join(cluster_config_path, 'shared_values.yml')
  end

  def shared_vault_path
    @shared_vault_path ||= File.join(cluster_config_path, 'shared_vault.yml')
  end

  def inventory_directory
    @inventory_directory ||= File.join(cluster_config_path, 'inventory')
  end

  def inventory_path(filename=nil)
    @inventory_path ||= File.join(inventory_directory, filename || 'inventory.yml')
  end

  def kubeconf_directory
    File.join(cluster_config_path, 'kubeconfs')
  end

  def master_kubeconf_path
    @master_kubeconf_path ||= File.join(kubeconf_directory, 'master.yml')
  end

  def cluster_config_path
    @cluster_config_path ||= File.join(base_path, cluster_name)
  end
end
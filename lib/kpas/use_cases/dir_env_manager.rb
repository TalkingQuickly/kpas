class DirEnvManager
  def initialize(cluster_path_facts, target_directory)
    @cluster_path_facts = cluster_path_facts
    @target_directory = target_directory
  end

  def create_dir_env_file
    shared_templates_path = File.join(CLI.cli_path, 'templates')

    render_template_to_file(
      File.join(shared_templates_path, '.envrc.erb'),
      File.join(target_directory, '.envrc')
    )

    system("direnv allow #{target_directory}")
  end

  attr_reader :cluster_path_facts, :target_directory

  private

  def kubeconf_path
    cluster_path_facts.master_kubeconf_path 
  end

  def render_template_to_file(template_path, output_path)
    data = render_template(template_path)
    write_file(output_path, data)
  end

  def render_template(path)
    ERB.new(File.read(path)).result(binding)
  end

  def write_file(path, contents)
    File.open(path, 'w') { |file| file.write(contents) }
  end
end
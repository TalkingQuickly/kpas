
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kpas/version"

Gem::Specification.new do |spec|
  spec.name          = "kpas"
  spec.version       = Kpas::VERSION
  spec.authors       = ["Ben Dixon"]
  spec.email         = ["ben@talkingquickly.co.uk"]

  spec.summary       = "kpas is a cli for creating and managing easy to use Kubernetes PaaS environments"
  spec.description   = "todo"
  spec.homepage      = "https://github.com/talkingquickly/kpas"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/talkingquickly/kpas"
    spec.metadata["changelog_uri"] = "https://github.com/talkingquickly/kpas/CHANELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.20"
  spec.add_dependency 'ansible-vault', '~> 0.1.0'

  spec.add_development_dependency 'pry', '~> 0.13.1'
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
end

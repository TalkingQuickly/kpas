# Kpas

Kpas allows engineers who don't have time for devops to create kubernetes clusters across providers and deploy applications to them in just a couple of commands.

In just two commands kpas provides a fully working cluster with CI, git push deployment, automated docker builds, docker registry and simple log aggregation.

It currently works across:

- Hetzner Cloud
- GCP (GKE)
- AWS (EKS)
- Bare Metal / Generic VM's

## What is it

Kpas (a riff on Kubernetes Platform As a Service) provides a simple CLI for creating standardised clusters across cloud, VM and Bare Metal providers.

It also provides an optional, opinionated layer on top of these cluster using best in class open source software which includes:

- In-cluster Registry
- CI and Git Server
- Nginx Ingress & SSL with Lets Encrypt
- Centralised Logging & Metrics
- A CLI for generating clusters and adding apps

kpas an opinionated, out of the box "release ready" configuration for a typical modern web application stack. A typical workflow is:

- Provision a cluster with Kpas
- Add a suitable helm chart to your application
- `git push` your web application to have it automatically deployed

Kpas is based around ansible and helm, so there's nothing proprietary or magic. It's "just" glue to make a common task quick and painless.

## Why does Kpas exist

Kubernetes is rapidly becoming the common runtime for the internet. The benefits of a single abstraction like this are already being realised in the Enterprise. Kpas aims to make the efficiency of a common runtime for everything available to everyone from individual developers wanting to efficiently run lots of side projects to startups wanting to put a solid foundation for future growth in place.

## Installation

Kpas is meant to be installed globally as a CLI tool. You can do this with:

```
gem install kpas
```

You may have to run `asdf reshim ruby` or equivalent if you use a version manager which intercepts binaries. `which kpas` can 

@TODO note that kpas 1.0.0 has not yet been released so is not yet available on Rubygems, see Developnent below for information about installing from source.

## Usage

Enter `kpas` to view the subcommands and documentation.

```
Commands:
  kpas cluster         # Operations for manipulating an existing KPAS cluster
  kpas config          # Operations for manipulating global KPAS configuration
  kpas generic_vm      # Operations for generating and bootstrapping cluster based on generic existing VM's
  kpas gke             # Operations for generating and bootstrapping GKE based clusters
  kpas help [COMMAND]  # Describe available commands or one specific command
  kpas hetzner_cloud   # Operations for generating and bootstrapping Hetzner Cloud based clusters
```

To bootstrap a cluset on Hetzner Cloud as an example you could run:

```
kpas hetzner_cloud bootstrap my-first-cluster
```

More documentation coming soon.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/talkingquickly/kpas.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

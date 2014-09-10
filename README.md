# Storm Chef Cookbook

This cookbook was originally based off of the fork from [yury-egorenkov/storm-cookbook](https://github.com/yury-egorenkov/storm-cookbook)

Initial focus is for convergence of a single node

## Requirements

Zookeeper is expected to be installed.  It's recommended to use the community
cookbook by [bbaugher/apache_zookeeper](https://github.com/bbaugher/apache_zookeeper)
as it is being actively maintained.

## Services

Upstart scripts are configured for each of the services installed, and by
default will be started.  Their state can be changed manually with the
`sudo [start,stop,restart] storm-[service]` commands.

## Recipes

The recipes should be called in two parts.  First the installation, and second
the configuration.

**Installation**

Recipe: `storm::default`

Storm will have two install methods `"package"` and `"source"`.  Currently,
`"source"` installations are not converging, so let's stick with `"package"`.
Installation can be specified by setting the following attributes:

```ruby
default[:storm][:install_method] = "package"
default[:storm][:short_version] = "0.9.2-incubating"
```

**Configuration**

The node can be configured in one of two configurations.  First as a
full-stack where the nimbus, supervisor, ui, and drpc services are all installed.

* Recipe: `storm::singlenode`

Otherwise the node can be configured to perform on of the services.

* Recipe: `storm::nimbus`
* Recipe: `storm::supervisor`
* Recipe: `storm::ui`
* Recipe: `storm::drpc`

## Storm UI

The storm ui is available via port 8080.  If using local virtualization,
port forward to the host's 8080 port to see the storm ui that will display
summaries of the cluster, topologies, supervisors, and nimbus.

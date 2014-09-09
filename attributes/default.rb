#
# Cookbook Name:: storm-project
# Attribute:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

default[:storm][:deploy][:user] = "storm"
default[:storm][:deploy][:group] = "storm"

default[:storm][:nimbus][:host] = "localhost"
default[:storm][:supervisor][:hosts] = %w{ localhost }

default[:storm][:nimbus][:childopts] = "-Xmx512m -Djava.net.preferIPv4Stack=true"

default[:storm][:supervisor][:childopts] = "-Xmx512m -Djava.net.preferIPv4Stack=true"
default[:storm][:supervisor][:workerports] = (6700..6706).to_a
default[:storm][:worker][:childopts] = "-Xmx512m -Djava.net.preferIPv4Stack=true"

default[:storm][:ui][:childopts] = "-Xmx512m -Djava.net.preferIPv4Stack=true"

default[:storm][:version] = "0.9.2-incubating"
default[:storm][:packages] = %w{ curl unzip build-essential pkg-config libtool autoconf git-core uuid-dev python-dev zookeeper }
default[:storm][:path][:root] = "/etc/storm"

## Dependent on resolved node attributes.  Override these as well if
## another version is required in a wrapper cookbook
default[:storm][:remote_path] = ::File.join("http://apache.mirror.iweb.ca/incubator/storm/",
                                            "apache-storm-#{node[:storm][:version]}")
default[:storm][:remote_file] = "apache-storm-#{node[:storm][:version]}.zip"

default[:storm][:path][:version] = ::File.join(node[:storm][:path][:root],
                                               "apache-storm-#{node[:storm][:version]}")
default[:storm][:path][:stormdata] = ::File.join(node[:storm][:path][:root],
                                               "storm-data")
default[:storm][:path][:java_lib] = "/usr/local/lib:/usr/lib"
default[:storm][:path][:pid] = "/var/run/storm-drpc.pid"

default[:storm][:drpc] = {
  :mem => "768m"
}

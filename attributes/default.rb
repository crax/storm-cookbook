#
# Cookbook Name:: storm
# Attribute:: default
#

default[:storm][:deploy] = {
  :user => "storm",
  :group => "storm"
}

default[:storm][:short_version] = "0.9.2-incubating"
default[:storm][:version] = "v#{node[:storm][:short_version]}"
default[:storm][:long_version] = "apache-storm-#{node[:storm][:short_version]}"

default[:storm][:install_method] = "package"
# default[:storm][:packages] = %w{ build-essential pkg-config libtool autoconf uuid-dev python-dev }
default[:storm][:packages] = %w{ }

default[:storm][:package] = {
  :packages => %w{ },
  :url => "http://mirror.reverse.net/pub/apache/incubator/storm/apache-storm-#{node[:storm][:short_version]}",
  :file => "#{node[:storm][:long_version]}.tar.gz"
}

default[:storm][:git] = {
  :packages => %w{ },
  :url => "https://github.com/apache/incubator-storm.git",
}

default[:storm][:path] = {
  :root => "/etc/storm",
  :version => ::File.join("/etc/storm", node[:storm][:long_version]),
  :stormdata => "/etc/storm/storm-data",
  :java_lib => "/usr/local/lib:/usr/lib",
  :pid => "/var/run/storm-drpc.pid",
}

default[:storm][:init_style] = default[:init_package]
default[:storm][:init_style] = "upstart" if default[:storm][:init_style].nil?

default[:storm][:nimbus] = {
  :host => "localhost",
  :childopts => "-Xmx512m -Djava.net.preferIPv4Stack=true"
}
default[:storm][:supervisor] = {
  :childopts => "-Xmx512m -Djava.net.preferIPv4Stack=true",
  :workerports => (6700..6706).to_a
}
default[:storm][:worker] = {
  :childopts => "-Xmx512m -Djava.net.preferIPv4Stack=true"
}
default[:storm][:drpc] = {
  :mem => "768m"
}
default[:storm][:ui] = {
  :childopts => "-Xmx512m -Djava.net.preferIPv4Stack=true"
}

default[:storm][:zookeeper] = {
  :hosts => %w{ localhost }
}

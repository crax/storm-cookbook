include_recipe "storm"

storm_path = "/#{node[:storm][:deploy][:user]}/apache-storm-#{node[:storm][:version]}"

template "Storm conf file" do
  path "/#{node[:storm][:deploy][:user]}/apache-storm-#{node[:storm][:version]}/conf/storm.yaml"
  source "singlenode.yaml.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode 0644
end

file "/#{node[:storm][:deploy][:user]}/apache-storm-#{node[:storm][:version]}/lib/netty-3.6.3.Final.jar" do
  action :delete
end

# Update netty to 3.9.2
remote_file "/#{node[:storm][:deploy][:user]}/apache-storm-#{node[:storm][:version]}/lib/netty-3.9.2.Final.jar" do
  source "http://central.maven.org/maven2/io/netty/netty/3.9.2.Final/netty-3.9.2.Final.jar"
  action :create_if_missing
end

['nimbus', 'supervisor', 'drpc', 'ui'].each do |service|
  package = "backtype.storm.daemon.#{service}"
  package = 'backtype.storm.ui.core' if service == 'ui'

  bash "Start #{service}" do
    user node[:storm][:deploy][:user]
    cwd storm_path
    code <<-EOH
    pid=$(pgrep -f #{package})
    if [ -z $pid ]; then
      ./bin/storm #{service} &
    fi
    EOH
  end
end
#
# Cookbook Name:: storm
# Recipe:: nimbus
#

include_recipe "storm::default"

template "Storm conf file" do
  path "/home/#{node[:storm][:deploy][:user]}/apache-storm-#{node[:storm][:version]}/conf/storm.yaml"
  source "nimbus.yaml.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode 0644
end

bash "Start nimbus" do
  user node[:storm][:deploy][:user]
  cwd "/home/#{node[:storm][:deploy][:user]}"
  code <<-EOH
  pid=$(pgrep -f backtype.storm.daemon.nimbus)
  if [ -z $pid ]; then
    nohup apache-storm-#{node[:storm][:version]}/bin/storm nimbus >>nimbus.log 2>&1 &
  fi
  EOH
end

template "/etc/init/storm-nimbus.conf" do
  source "upstart/storm-nimbus.conf.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode "0644"
  variables(
    :user => node[:storm][:deploy][:user],
    :storm_home => ::File.join(node[:storm][:path][:root], node[:storm][:long_version]),
    :java_lib_path => node[:storm][:path][:java_lib],
  )
  notifies :restart, "service[storm-nimbus]"
end

template "storm_conf" do
  path ::File.join(node[:storm][:path][:version], "conf/storm.yaml")
  source "drpc.yaml.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode "0644"
  variables(
    :zoo_servers => node[:storm][:supervisor][:hosts],
    :stormdata => node[:storm][:path][:stormdata],
    :java_lib_path => node[:storm][:path][:java_lib]
  )
  notifies :restart, "service[storm-drpc]"
end

service "storm-drpc" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

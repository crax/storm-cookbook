#
# Cookbook Name:: storm
# Recipe:: drpc
#

template "/etc/init/storm-drpc.conf" do
  source "upstart/storm-drpc.conf.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode "0644"
  variables(
    :user => node[:storm][:deploy][:user],
    :storm_home => ::File.join(node[:storm][:path][:root], "current"),
    :java_lib_path => node[:storm][:path][:java_lib],
    :drpc_pid => node[:storm][:path][:pid],
    :drpc_mem => node[:storm][:drpc][:mem],
  )
  notifies :restart, "service[storm-drpc]"
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

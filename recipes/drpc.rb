#
# Cookbook Name:: storm-project
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/etc/init/storm-drpc.conf" do
  source "upstart/storm-drpc.conf.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode "0644"
  notifies :restart, "service[storm-drpc]"
end

template "storm_conf" do
  path ::File.join(node[:storm][:path][:version], "conf/storm.yaml")
  source "drpc.yaml.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode "0644"
  notifies :restart, "service[storm-drpc]"
end

template "/etc/default/storm-drpc" do
  source "env/storm-drpc.erb"
  mode "0664"
  variables(
    :zoo_servers => node[:storm][:supervisor][:hosts],
    :stormdata => node[:storm][:path][:stormdata],
    :java_lib_path => node[:storm][:path][:java_lib]
  )
end

service "storm-drpc" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

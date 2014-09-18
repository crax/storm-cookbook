#
# Cookbook Name:: storm
# Recipe:: supervisor
#

include_recipe "storm::default"

template "storm.yaml" do
  path ::File.join(node[:storm][:path][:version], "conf/storm.yaml")
  source "supervisor.yaml.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode 0644
  notifies :restart, "service[storm-supervisor]"
end

include_recipe "storm::service_supervisor"

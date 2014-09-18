#
# Cookbook Name:: storm
# Recipe:: nimbus
#

include_recipe "storm::default"

template "storm.yaml" do
  path ::File.join(node[:storm][:path][:version], "conf/storm.yaml")
  source "nimbus.yaml.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode 0644
  notifies :restart, "service[storm-drpc]"
  notifies :restart, "service[storm-nimbus]"
end

include_recipe "storm::service_nimbus"
include_recipe "storm::service_drpc"

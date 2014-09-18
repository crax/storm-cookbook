#
# Cookbook Name:: storm
# Recipe:: singlenode
#

include_recipe "storm::default"

template "storm.yaml" do
  path ::File.join(node[:storm][:path][:version], "conf/storm.yaml")
  source "singlenode.yaml.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode 0644
  notifies :restart, "service[storm-drpc]"
  notifies :restart, "service[storm-nimbus]"
  notifies :restart, "service[storm-supervisor]"
  notifies :restart, "service[storm-ui]"
end

["nimbus", "supervisor", "drpc", "ui"].each do |service_name|
  include_recipe "storm::service_#{service_name}"
end

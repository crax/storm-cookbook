#
# Cookbook Name:: storm
# Recipe:: ui
#

include_recipe "storm::default"

template "storm.yaml" do
  path ::File.join(node[:storm][:path][:version], "conf/storm.yaml")
  source "ui.yaml.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode 0644
  notifies :restart, "service[storm-ui]"
end

include_recipe "storm::service_ui"

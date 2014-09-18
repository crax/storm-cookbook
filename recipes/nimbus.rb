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

include_recipe "storm::service_nimbus"

include_recipe "storm::drpc"

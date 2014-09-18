#
# Cookbook Name:: storm
# Recipe:: drpc
#

include_recipe "storm::default"

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

include_recipe "storm::service_drpc"

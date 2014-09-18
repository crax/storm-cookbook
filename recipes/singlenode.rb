#
# Cookbook Name:: storm
# Recipe:: singlenode
#

include_recipe "storm::default"

storm_home = node[:storm][:path][:version]

template "Storm conf file" do
  path "#{storm_home}/conf/storm.yaml"
  source "singlenode.yaml.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode 0644
  variables(
    :user => node[:storm][:deploy][:user],
    :storm_home => storm_home,
    :zoo_servers => node[:storm][:supervisor][:hosts],
    :stormdata => node[:storm][:path][:stormdata],
    :java_lib_path => node[:storm][:path][:java_lib],
    :drpc_pid => node[:storm][:path][:pid],
    :drpc_mem => node[:storm][:drpc][:mem],
  )
end

["nimbus", "supervisor", "drpc", "ui"].each do |service_name|
  include_recipe "storm::service_#{service_name}"
end

#
# Cookbook Name:: storm
# Recipe:: singlenode
#

include_recipe "storm"

user_path = node[:storm][:path][:root]
storm_path = ::File.join(node[:storm][:path][:root], "current")

template "Storm conf file" do
  path "#{storm_path}/conf/storm.yaml"
  source "singlenode.yaml.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode 0644
  variables(
    :user => node[:storm][:deploy][:user],
    :storm_home => ::File.join(node[:storm][:path][:root], "current"),
    :zoo_servers => node[:storm][:supervisor][:hosts],
    :stormdata => node[:storm][:path][:stormdata],
    :java_lib_path => node[:storm][:path][:java_lib],
    :drpc_pid => node[:storm][:path][:pid],
    :drpc_mem => node[:storm][:drpc][:mem],
  )
end

file "#{storm_path}/lib/netty-3.6.3.Final.jar" do
  action :delete
end

# Update netty to 3.9.2
remote_file "#{storm_path}/lib/netty-3.9.2.Final.jar" do
  source "http://central.maven.org/maven2/io/netty/netty/3.9.2.Final/netty-3.9.2.Final.jar"
  action :create_if_missing
end

['nimbus', 'supervisor', 'drpc', 'ui'].each do |service_name|
  conf_file = "storm-#{service_name}.conf"
  conf_path = "/etc/init/#{conf_file}"

  template "Upstart #{conf_file}" do
    path conf_path
    source "upstart/#{conf_file}.erb"
    owner node[:storm][:deploy][:user]
    group node[:storm][:deploy][:group]
    mode 0644
    variables(
      :user => node[:storm][:deploy][:user],
      :storm_home => ::File.join(node[:storm][:path][:root], "current"),
      :java_lib_path => node[:storm][:path][:java_lib],
      :drpc_pid => node[:storm][:path][:pid],
      :drpc_mem => node[:storm][:drpc][:mem],
    )
  end

  service "storm-#{service_name}" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
  end
end

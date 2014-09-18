#
# Cookbook Name:: storm
# Recipe:: singlenode
#

include_recipe "storm::default"

user_path = node[:storm][:path][:root]
storm_home = ::File.join(node[:storm][:path][:root], node[:storm][:long_version])

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
  init_style = node[:storm][:init_style]
  conf_file = case init_style
              when "upstart"
                "storm-#{service_name}.conf"
              when "init"
                "storm-#{service_name}"
              end
  conf_path = case init_style
              when "upstart"
                "/etc/init/#{conf_file}"
              when "init"
                "/etc/init.d/#{conf_file}"
              end

  template conf_path do
    path conf_path
    source "#{init_style}/#{conf_file}.erb"
    mode 0766
    variables(
      :user => node[:storm][:deploy][:user],
      :storm_home => storm_home,
      :java_lib_path => node[:storm][:path][:java_lib],
      :drpc_pid => node[:storm][:path][:pid],
      :drpc_mem => node[:storm][:drpc][:mem],
    )
    notifies :restart, "service[storm-#{service_name}]", :delayed
  end

  service "storm-#{service_name}" do
    provider Chef::Provider::Service::Upstart if init_style == "upstart"
    supports :status => true, :restart => true
    action [ :enable, :start ]
  end
end

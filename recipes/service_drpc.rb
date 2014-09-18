init_source = "#{node[:storm][:init_style]}/#{conf_file("drpc")}.erb"
init_path = conf_path("drpc")

template init_path do
  path init_path
  source init_source
  mode 0755
  variables(
    :user => node[:storm][:deploy][:user],
    :storm_home => node[:storm][:path][:version],
    :java_lib_path => node[:storm][:path][:java_lib]
  )
  notifies :restart, "service[storm-#{"drpc"}]", :delayed
end

service "storm-#{"drpc"}" do
  provider Chef::Provider::Service::Upstart if node[:storm][:init_style] == "upstart"
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

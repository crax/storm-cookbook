init_source = "#{node[:storm][:init_style]}/#{conf_file("supervisor")}.erb"
init_path = conf_path("supervisor")

template init_path do
  path init_path
  source init_source
  mode 0755
  variables(
    :user => node[:storm][:deploy][:user],
    :storm_home => node[:storm][:path][:version],
    :java_lib_path => node[:storm][:path][:java_lib]
  )
  notifies :restart, "service[storm-#{"supervisor"}]", :delayed
end

service "storm-#{"supervisor"}" do
  provider Chef::Provider::Service::Upstart if node[:storm][:init_style] == "upstart"
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

include_recipe "storm"

user_path = node[:storm][:path][:root]
storm_path = node[:storm][:path][:storm]

template "Storm conf file" do
  path "#{storm_path}/conf/storm.yaml"
  source "singlenode.yaml.erb"
  owner node[:storm][:deploy][:user]
  group node[:storm][:deploy][:group]
  mode 0644
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
  package = "backtype.storm.daemon.#{service_name}"
  package = 'backtype.storm.ui.core' if service_name == 'ui'

  # bash "Start #{service_name}" do
  #   user node[:storm][:deploy][:user]
  #   cwd storm_path
  #   code <<-EOH
  #   pid=$(pgrep -f #{package})
  #   if [ -z $pid ]; then
  #     ./bin/storm #{service_name} &
  #   fi
  #   EOH
  # end

  conf_file = "storm-#{service_name}.conf"
  conf_path = "/etc/init/#{conf_file}"
  template "Upstart #{conf_file}" do
    path conf_path
    source "upstart/#{conf_file}.erb"
    owner node[:storm][:deploy][:user]
    group node[:storm][:deploy][:group]
    mode 0644
  end

  service "storm-#{service_name}" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
  end
end













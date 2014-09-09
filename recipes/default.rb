#
# Cookbook Name:: storm
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

group node[:storm][:deploy][:group]
user node[:storm][:deploy][:user] do
  gid node[:storm][:deploy][:group]
  comment "storm user"
  system true
  shell "/bin/false"
end

node[:storm][:packages].each do |pkg|
  package pkg do
    retries 2
    action :install
  end
end

dirs = []
dirs << node[:storm][:path][:root]
dirs << node[:storm][:path][:stormdata]

dirs.each do |dir|
  directory dir do
    recursive true
  end
end

local_file = ::File.join(Chef::Config[:file_cache_path],
                         node[:storm][:remote_file])
remote_file local_file do
  source ::File.join(node[:storm][:remote_path], node[:storm][:remote_file])
  action :create_if_missing
  notifies :run, "execute[extract_storm]", :immediately
  not_if { ::File.exists?(node[:storm][:path][:version]) }
end

execute "extract_storm" do
  command "unzip #{local_file} -d #{node[:storm][:path][:root]}"
  action :nothing
  notifies :create, "link[#{::File.join(node[:storm][:path][:root], "current")}]", :immediately
end

link ::File.join(node[:storm][:path][:root], "current") do
  to node[:storm][:path][:version]
end

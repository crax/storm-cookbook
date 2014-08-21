#
# Cookbook Name:: storm-project
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node[:storm][:packages].each do |pkg|
  package pkg do
    retries 2
    action :install
  end
end

directory node[:storm][:path][:root] do
  recursive true
end

local_file = ::File.join(Chef::Config[:file_cache_path],
                         node[:storm][:remote_file])
remote_file local_file do
  source ::File.join(node[:storm][:remote_path], node[:storm][:remote_file])
  action :create_if_missing
  notifies :run, "execute[extract_storm]"
  not_if { ::File.exists?(node[:storm][:path][:version])}
end

execute "extract_storm" do
  command "unzip #{local_file} -d #{node[:storm][:path][:root]}"
  action :nothing
end

link ::File.join(node[:storm][:path][:root], "current") do
  to node[:storm][:path][:version]
end

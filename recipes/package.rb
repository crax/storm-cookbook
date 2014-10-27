#
# Cookbook Name:: storm
# Recipe:: package
#

group node[:storm][:deploy][:group]
user node[:storm][:deploy][:user] do
  gid node[:storm][:deploy][:group]
  comment "storm user"
  system true
  shell "/bin/false"
end

# Install general packages required
node[:storm][:packages].each do |pkg|
  package pkg
end

# Install packages required for a "package" install
node[:storm][:package][:packages].each do |pkg|
  package pkg
end

node[:storm][:path].each do |_, dir|
  directory dir do
    owner node[:storm][:deploy][:user]
    group node[:storm][:deploy][:group]
    recursive true
  end
end

local_path = ::File.join(::Chef::Config[:file_cache_path],
                         node[:storm][:package][:file])
storm_bin = ::File.join(node[:storm][:path][:root],
                        node[:storm][:long_version],
                        "bin/storm")

remote_file local_path do
  source ::File.join(node[:storm][:package][:url], node[:storm][:package][:file])
  action :create_if_missing
  notifies :run, "execute[extract_storm]", :immediately
  not_if { ::File.exists?(storm_bin) }
end

execute "extract_storm" do
  user node[:storm][:deploy][:user]
  command "tar -xf #{local_path} -C #{node[:storm][:path][:root]}"
  not_if { ::File.exists?(storm_bin) }
end

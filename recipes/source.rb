#
# Cookbook Name:: storm
# Recipe:: source
#

include_recipe "maven"

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
    recursive true
  end
end

git ::File.join(node[:storm][:path][:root], node[:storm][:long_version]) do
  repository node[:storm][:git][:url]
  reference node[:storm][:version]
end

## This build is currently not working for some reason
## Defaulting to package install
execute "build storm" do
  command "mvn clean install"
  cwd ::File.join(node[:storm][:path][:root], node[:storm][:long_version])
end

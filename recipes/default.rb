#
# Cookbook Name:: storm
# Recipe:: default
#

# use install method
include_recipe 'java::default'

case node[:storm][:install_method]
  when "package"
    include_recipe "storm::package"
  when "source"
    include_recipe "storm::source"
  else
    Chef::Application.fatal("Unknown install method #{node[:storm][:install_method]}")
end

#
# Author:: NagaLakshmi <nagalakshmi.n@cloudenablers.com>
# Cookbook Name:: nrpe
# Recipe:: default
#
# Copyright 2015, Cloudenablers
#
# All rights reserved.Do not redistribute.
#

# install the nrpe daemon and plugins using the appropriate recipe(s)
include_recipe "nrpe::#{node['nrpe']['install_method']}_install"

# determine hosts that NRPE will allow monitoring from. Start with localhost
monitoring_host = ['127.0.0.1']

# add nagios server ip to allowed host in order to monitor
if node['nrpe']['allowed_hosts']
  allowed_hosts = node['nrpe']['allowed_hosts'].split(",")
  monitoring_host.concat allowed_hosts
end

include_dir = "#{node['nrpe']['conf_dir']}/nrpe.d"

directory include_dir do
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode '0755'
end

template "#{node['nrpe']['conf_dir']}/nrpe.cfg" do
  source 'nrpe.cfg.erb'
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode '0644'
  variables(
    :monitoring_host => monitoring_host,
    :nrpe_directory => include_dir
  )
  notifies :restart, "service[#{node['nrpe']['service_name']}]"
end

remote_file "#{node['nrpe']['plugin_dir'] }/check_memory" do
  source "#{node['nrpe']['plugins']['url']}/check_memory"
  mode "0755"
  owner node['nrpe']['user']
  group node['nrpe']['group']
  action :create
end

remote_file "#{node['nrpe']['plugin_dir'] }/check_cpu" do
  source "#{node['nrpe']['plugins']['url']}/check_cpu"
  mode "0755"
  owner node['nrpe']['user']
  group node['nrpe']['group']  
  action :create
end

nrpe_check 'add-memory' do
  command_name 'check_memory'
  action :add  
end

nrpe_check 'add-cpu' do
  command_name 'check_cpu'
  action :add  
end

nrpe_check 'add-load' do
  command_name 'check_load'
  action :add  
end

nrpe_check 'add-disk' do
  command "#{node['nrpe']['plugin_dir']}/check_disk -p $ARG3$"
  command_name 'check_disk'
  action :add  
end

nrpe_check 'add-uptime' do
  command "#{node['nrpe']['plugin_dir']}/check_uptime -u $ARG3$"
  command_name 'check_uptime'
  action :add  
end

service node['nrpe']['service_name'] do
  action [:start, :enable]
  supports :restart => true, :reload => true, :status => true
end

remove_dirs = "#{Chef::Config[:file_cache_path]}/nrpe-#{node['nrpe']['version']}.tar.gz #{Chef::Config[:file_cache_path]}/nrpe-#{node['nrpe']['version']}"

execute "Remove nrpe source" do
    command "rm -rf #{remove_dirs}"
end


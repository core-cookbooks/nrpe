#
# Author:: NagaLakshmi <nagalakshmi.n@cloudenablers.com>
# Cookbook Name:: nrpe
# Recipe:: source_plugins
#
# Copyright 2015, Cloudenablers
#
# All rights reserved.Do not redistribute.
#


plugins_version = node['nrpe']['plugins']['version']

remote_file "#{Chef::Config[:file_cache_path]}/nagios-plugins-#{plugins_version}.tar.gz" do
  source "#{node['nrpe']['plugins']['url']}/nagios-plugins-#{plugins_version}.tar.gz"
  action :create
end

bash 'compile-monitoring-plugins' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxvf nagios-plugins-#{plugins_version}.tar.gz
    cd nagios-plugins-#{plugins_version}
    ./configure --with-nagios-user=#{node['nrpe']['user']} \
                --with-nagios-group=#{node['nrpe']['group']} \
                --prefix=/usr \
                --libexecdir=#{node['nrpe']['plugin_dir']}
    make -s
    make install
  EOH
  creates "#{node['nrpe']['plugin_dir']}/check_users"
end

=begin
directory node['nrpe']['plugin_dir'] do
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode  '0755'
  recursive true  
  action :create  
end
=end

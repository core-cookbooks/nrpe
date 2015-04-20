#
# Author:: NagaLakshmi <nagalakshmi.n@cloudenablers.com>
# Cookbook Name:: nrpe
# Recipe:: source_nrpe
#
# Copyright 2015, Cloudenablers
#
# All rights reserved.Do not redistribute.
#

remote_file "#{Chef::Config[:file_cache_path]}/nrpe-#{node['nrpe']['version']}.tar.gz" do
  source "#{node['nrpe']['url']}/nrpe-#{node['nrpe']['version']}.tar.gz"
  action :create
end

template "/etc/init.d/#{node['nrpe']['service_name']}" do
  source 'nagios-nrpe-server.erb'
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode  '0755'
end

directory node['nrpe']['conf_dir'] do
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode  '0755'
end

bash 'compile-nagios-nrpe' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxvf nrpe-#{node['nrpe']['version']}.tar.gz
    cd nrpe-#{node['nrpe']['version']}
    ./configure --prefix=/usr \
                --sysconfdir=/etc \
                --localstatedir=/var \
                --libexecdir=#{node['nrpe']['plugin_dir']} \
                --libdir=#{node['nrpe']['home']} \
                --enable-command-args \
                --with-nagios-user=#{node['nrpe']['user']} \
                --with-nagios-group=#{node['nrpe']['group']} \
                --with-ssl=/usr/bin/openssl \
                --with-ssl-lib=#{node['nrpe']['ssl_lib_dir']}
    make -s
    make install
  EOH
  creates "#{node['nrpe']['plugin_dir']}/check_nrpe" # perhaps we could replace this with a version check to allow upgrades
end

#
# Author:: NagaLakshmi <nagalakshmi.n@cloudenablers.com>
# Cookbook Name:: nrpe
# Recipe:: source_install
#
# Copyright 2015, Cloudenablers
#
# All rights reserved.Do not redistribute.
#

# make sure gcc and make are installed
include_recipe 'build-essential'

pkgs = value_for_platform_family(
    %w(rhel fedora) => %w(openssl-devel bc make tar),
    'debian' => %w(libssl-dev bc make tar),
    'gentoo' => ['bc'],
    'default' => %w(libssl-dev bc make tar)
  )

# install the necessary prereq packages for compiling NRPE
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

user node['nrpe']['user'] do
  system true
end

group node['nrpe']['group'] do
  members [node['nrpe']['user']]
end

# compile both nrpe daemon and the monitoring plugins
include_recipe 'nrpe::source_nrpe'
include_recipe 'nrpe::source_plugins'

#
# Author:: NagaLakshmi <nagalakshmi.n@cloudenablers.com>
# Cookbook Name:: nrpe
# Recipe:: package_install
#
# Copyright 2015, Cloudenablers
#
# All rights reserved.Do not redistribute.
#

# nrpe packages are available in EPEL on rhel / fedora platforms
# fedora 17 and later don't require epel
if platform_family?('rhel', 'fedora')
  unless platform?('fedora') && node['platform_version'] < 17
    include_recipe 'yum-epel'
  end
end

# install the nrpe packages specified in the ['nrpe']['packages'] attribute
node['nrpe']['packages'].each do |pkg|
  package pkg do
    options node['nrpe']['package']['options'] unless node['nrpe']['package']['options'].nil?
  end
end

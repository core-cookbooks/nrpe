#
# Author:: Nagalakshmi <nagalakshmi.n@cloudenablers.com>
# Cookbook Name:: nrpe
# Attributes:: default
#
# Copyright 2015, Cloudenablers
#
# All rights reserved. Do not redistribute.
#

# nrpe package options
default['nrpe']['package']['options'] = nil
default['nrpe']['install_method']    = 'source'

# nrpe daemon user/group
default['nrpe']['user']  = 'nagios'
default['nrpe']['group'] = 'nagios'

# config file options
default['nrpe']['allow_bash_command_substitution'] = nil
default['nrpe']['server_port']                     = 5666
default['nrpe']['server_address']                  = nil
default['nrpe']['command_prefix']                  = nil
default['nrpe']['log_facility']                    = nil
default['nrpe']['debug']                           = 0
default['nrpe']['dont_blame_nrpe']                 = 1
default['nrpe']['command_timeout']                 = 60
default['nrpe']['connection_timeout']              = nil

# Nagios plugins from source installation
default['nrpe']['plugins']['version']  = '2.0.3'
default['nrpe']['plugins']['url']      = 'https://region-a.geo-1.objects.hpcloudsvc.com/v1/68342917034742/Cnext/files/monitoring/plugins'


# nrpe from source installation
default['nrpe']['version']  = '2.15'
default['nrpe']['url']      = 'https://region-a.geo-1.objects.hpcloudsvc.com/v1/68342917034742/Cnext/files/monitoring/source'

# authorization options
default['nrpe']['allowed_hosts'] = "37.72.173.50"
default['nrpe']['multi_environment_monitoring'] = false

# platform specific values
case node['platform_family']
when 'debian'
  default['nrpe']['pid_file']          = '/var/run/nagios/nrpe.pid'
  default['nrpe']['home']              = '/usr/lib/nagios'
  default['nrpe']['plugin_dir']        = '/usr/lib/nagios/plugins'
  default['nrpe']['conf_dir']          = '/etc/nagios'
  if node['kernel']['machine'] == 'i686'
    default['nrpe']['ssl_lib_dir']     = '/usr/lib/i386-linux-gnu'
  else
    default['nrpe']['ssl_lib_dir']     = '/usr/lib/x86_64-linux-gnu'
  end
  if node['nrpe']['install_method'] == 'package'
    default['nrpe']['service_name']    = 'nagios-nrpe-server'
    default['nrpe']['packages']          = %w(nagios-nrpe-server nagios-plugins nagios-plugins-basic nagios-plugins-standard)
  else
    default['nrpe']['service_name']    = 'nrpe'
  end
when 'rhel', 'fedora'
  default['nrpe']['pid_file']          = '/var/run/nrpe.pid'
  if node['kernel']['machine'] == 'i686'
    default['nrpe']['home']            = '/usr/lib/nagios'
    default['nrpe']['ssl_lib_dir']     = '/usr/lib'
    default['nrpe']['plugin_dir']      = '/usr/lib/nagios/plugins'
  else
    default['nrpe']['home']            = '/usr/lib64/nagios'
    default['nrpe']['ssl_lib_dir']     = '/usr/lib64'
    default['nrpe']['plugin_dir']      = '/usr/lib64/nagios/plugins'
  end
  if node['nrpe']['install_method'] == 'package'
    default['nrpe']['packages']          = %w(nrpe nagios-plugins-disk nagios-plugins-load nagios-plugins-procs nagios-plugins-users)
  end
  default['nrpe']['service_name']      = 'nrpe'
  default['nrpe']['conf_dir']          = '/etc/nagios'
when 'freebsd'
  default['nrpe']['install_method']    = 'package'
  default['nrpe']['pid_file']          = '/var/run/nrpe2/nrpe2.pid'
  default['nrpe']['log_facility']      = 'daemon'
  default['nrpe']['service_name']      = 'nrpe2'
  default['nrpe']['conf_dir']          = '/usr/local/etc'
  if node['nrpe']['install_method'] == 'package'
    default['nrpe']['packages']          = %w(nrpe)
  end
else
  default['nrpe']['pid_file']          = '/var/run/nrpe.pid'
  default['nrpe']['home']              = '/usr/lib/nagios'
  default['nrpe']['ssl_lib_dir']       = '/usr/lib'
  default['nrpe']['service_name']      = 'nrpe'
  default['nrpe']['plugin_dir']        = '/usr/lib/nagios/plugins'
  default['nrpe']['conf_dir']          = '/etc/nagios'
end

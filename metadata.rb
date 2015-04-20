name             'nrpe'
maintainer       'nagalakshmi_n'
maintainer_email 'nagalakshmi.n@cloudenablers.com'
license          'All rights reserved.Licensed to Cloudenablers'
description      'Installs/Configures nrpe'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe 'default', 'Installs and configures a nrpe client'
%w(build-essential yum-epel).each do |cb|
  depends cb
end

%w(debian ubuntu redhat centos fedora scientific amazon oracle freebsd).each do |os|
  supports os
end

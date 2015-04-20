#
# Author:: NagaLakshmi <nagalakshmi.n@cloudenablers.com>
# Cookbook Name:: nrpe
# Provider:: check
#
# Copyright 2014, Cloudenablers
#
# All rights reserved.Do not redistribute.

def whyrun_supported?
  true
end

action :add do
  Chef::Log.info "Adding #{new_resource.command_name} to #{node['nrpe']['conf_dir']}/nrpe.d/"
  command = new_resource.command || "#{node['nrpe']['plugin_dir']}/#{new_resource.command_name}"
  file_contents = "command[#{new_resource.command_name}]=#{command}"
  file_contents += " -w $ARG1$"
  file_contents += " -c $ARG2$"
  file_contents += " #{new_resource.parameters}" unless new_resource.parameters.nil?
  f = file "#{node['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg" do
    owner node['nrpe']['user']
    group node['nrpe']['group']
    mode '0640'
    content file_contents
    notifies :reload, "service[#{node['nrpe']['service_name']}]"
  end
  new_resource.updated_by_last_action(f.updated_by_last_action?)
end

action :remove do
  if ::File.exist?("#{node['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg")
    Chef::Log.info "Removing #{new_resource.command_name} from #{node['nrpe']['conf_dir']}/nrpe.d/"
    f = file "#{node['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg" do
      action :delete
      notifies :reload, "service[#{node['nrpe']['service_name']}]"
    end
    new_resource.updated_by_last_action(f.updated_by_last_action?)
  end
end

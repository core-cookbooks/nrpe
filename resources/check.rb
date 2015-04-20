#
# Author:: NagaLakshmi <nagalakshmi.n@cloudenablers.com>
# Cookbook Name:: nrpe
# Resource:: check
#
# Copyright 2015, Cloudenablers
#
# All rights reserved.Do not redistribute.

actions :add, :remove

state_attrs :command,
            :command_name,
            :critical_condition,
            :parameters,
            :warning_condition

# Name of the nrpe check, used for the filename and the command name
attribute :command_name, :kind_of => String, :name_attribute => true

attribute :warning_condition, :kind_of => String, :default => nil
attribute :critical_condition, :kind_of => String, :default => nil
attribute :command, :kind_of => String
attribute :parameters, :kind_of => String, :default => nil

def initialize(*args)
  super
  @action = :add
end

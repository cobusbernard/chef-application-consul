#
# Cookbook Name:: chef-application-consul
# Recipe:: master
#
# Copyright (C) 2016 Cobus Bernard
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

instances = Array.new

search(:node, "roles:application-link-consul-master-role AND chef_environment:#{node.chef_environment}", :filter_result => { 'fqdn' => ['fqdn'] }).each do |result|
  Chef::Log.info("Node: #{result}")
  instances << result['fqdn']
end

if instances.length == 0
  instances << node['fqdn']
end

node.set['consul']['master']['instances'] = instances.sort
node.set['consul']['config']['server'] = true
node.set['consul']['config']['bootstrap_expect'] = 1

include_recipe 'chef-wrapper-consul::default'

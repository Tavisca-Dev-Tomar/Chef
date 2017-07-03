# Cookbook Name:: filebeat
# Recipe:: default
#
# Copyright 2017, Tavisca, Inc.
#
execute 'update' do
  command 'apt-get update -y'
  action :run
end

remote_file node['filebeat']['remotefile'] do
  source node['filebeat']['remotesource']
  action :create_if_missing
end

dpkg_package 'Filebeat' do
  source 'beats/filebe'
  action :install
end

template '/etc/filebeat/filebeat.yml' do
  source 'filebeat.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

service 'filebeat' do
   subscribes :start, 'file[/etc/filebeat', :immediately
end

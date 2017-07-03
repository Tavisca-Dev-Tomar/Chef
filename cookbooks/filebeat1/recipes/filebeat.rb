
# Cookbook Name:: filebeat
# Recipe:: default
#
# Copyright 2017, Tavisca, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


execute "update" do
  command "apt-get update -y"
  action :run
end

remote_file 'beats/filebeat' do
  source 'https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.2.2-amd64.deb'
  owner 'vagrant'
  group 'vagrant'
  mode '0755'
  action :create_if_missing
end

dpkg_package 'Filebeat' do
  source 'beats/filebeat/filebeat-5.2.2-amd64.deb'
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

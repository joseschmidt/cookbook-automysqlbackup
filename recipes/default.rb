#
# Cookbook Name:: automysqlbackup
# Recipe:: default
#
# Copyright 2012, James Hardie Building Products, Inc.
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
#

include_recipe 'mysql::ruby'
include_recipe 'chef-sugar'

item = node['automysqlbackup']

# retrieve contents of encrypted data bag (refer to chef-repo/ENCRYPTED.md)
secret = encrypted_data_bag_item(:encrypted, node.chef_environment)

# establish database server connection parameters
connection_info = {
  :host => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password'] ||
    secret['mysql']['root']
}


# Download automysqlbackup script from:
# http://surfnet.dl.sourceforge.net/project/automysqlbackup/AutoMySQLBackup/AutoMySQLBackup%20VER%202.5
# http://sourceforge.net/projects/automysqlbackup/
# and place in automysqlbackup/files/default/automysqlbackup.sh.
cookbook_file ::File.join('', 'etc', 'cron.daily', 'automysqlbackup.sh') do
  source  'automysqlbackup-2.5.1-01.sh'
  owner   'root'
  group   'root'
  mode    '0755'
end # cookbook_file ::File.join(...)


# create directory for configuration file
directory item['conf_dir'] do
  owner     'root'
  group     'root'
  mode      '0755'
  recursive true
end # directory item['conf_dir'] do


# create configuration file
template ::File.join(item['conf_dir'], item['conf_file']) do |t|
  source      'automysqlbackup.conf.erb'
  owner       'root'
  group       'root'
  mode        '0600'
  variables   :user => item['user'],
              :password => secret['automysqlbackup'],
              :backup_dir => item['backup_dir']
end # template ::File.join(...)


# create directory for backups
directory item['backup_dir'] do
  owner     'root'
  group     'root'
  mode      '0700'
  recursive true
end # directory item['backup_dir'] do


# grant privileges to user 'automysqlbackup' for automatic backups
mysql_database_user 'automysqlbackup' do
  connection connection_info
  password secret['automysqlbackup']
  host 'localhost'
  privileges ['SELECT', 'LOCK TABLES']
  action :grant
  only_if { secret['automysqlbackup'] }
end # mysql_database_user 'automysqlbackup'

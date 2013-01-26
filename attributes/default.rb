#
# Cookbook Name:: automysqlbackup
# Attributes:: default 
#

# configuration file settings
# TODO: review backup script to see if these are hard-coded
# TODO: remove attribtues, if so
default['automysqlbackup']['conf_dir']    =
  ::File.join('', 'etc', 'automysqlbackup')
default['automysqlbackup']['conf_file']   = 'automysqlbackup.conf'
default['automysqlbackup']['backup_dir']  =
  ::File.join('', 'var', 'backup', 'db')


# mysqlbackup user
default['automysqlbackup']['user']        = 'automysqlbackup'

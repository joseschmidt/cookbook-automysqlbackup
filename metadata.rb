# encoding: utf-8
name              'automysqlbackup'
maintainer        'James Hardie Building Products, Inc.'
maintainer_email  'doc.walker@jameshardie.com'
description       'Installs and configures automysqlbackup ' \
                  '(MySQL backup tool).'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
license           'Apache 2.0'
version           '0.2.0'

#--------------------------------------------------------------------- recipes
recipe            'automysqlbackup',
                  'Installs and configures automysqlbackup'

#------------------------------------------------------- cookbook dependencies
depends           'build-essential', '~> 1.4.4'
depends           'chef-sugar'
depends           'database', '~> 1.3.12'
depends           'mysql', '~> 2.1.0'

#--------------------------------------------------------- supported platforms
# tested
supports          'centos'

# platform_family?('rhel'): not tested, but should work
supports          'amazon'
supports          'oracle'
supports          'redhat'
supports          'scientific'

# platform_family?('debian'): not tested, but may work
supports          'debian'
supports          'ubuntu'

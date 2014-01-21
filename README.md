automysqlbackup Cookbook
========================
[![Build Status](https://travis-ci.org/jhx/cookbook-automysqlbackup.png?branch=master)](https://travis-ci.org/jhx/cookbook-automysqlbackup)

Installs and configures automysqlbackup (MySQL backup tool).


Requirements
------------
### Cookbooks
The following cookbooks are direct dependencies because they're used for common "default" functionality.

- `chef-sugar`
- `database`
- `mysql`

### Platforms
The following platforms are supported and tested under Test Kitchen:

- CentosOS 5.10, 6.5

Other RHEL family distributions are assumed to work. See [TESTING](TESTING.md) for information about running tests in Opscode's Test Kitchen.


Attributes
----------
Refer to `attributes/default.rb` for default values.

- `node['automysqlbackup']['conf_dir']` - directory location to store configuration
- `node['automysqlbackup']['conf_file']` - configuration filename
- `node['automysqlbackup']['backup_dir']` - backup directory location
- `node['automysqlbackup']['user']` - username to access the MySQL server


Recipes
-------
This cookbook provides one main recipe for configuring a node.

- `default.rb` - *Use this recipe* to install and configure `automysqlbackup`.

### default
This recipe installs and configures `automysqlbackup`.


Usage
-----
On client nodes, use the default recipe:

````javascript
{ "run_list": ["recipe[automysqlbackup]"] }
````

The following are the key items achieved by this cookbook:

- installs `automysqlbackup.sh` into `/etc/cron.daily`
- creates configuration directory `node['conf_dir]`
- creates configuration file `node['conf_file]`
- creates backup directory `node['backup_dir]`
- grants appropriate privileges to MySQL user `automysqlbackup`


License & Authors
-----------------
- Author:: Doc Walker (<doc.walker@jameshardie.com>)

````text
Copyright 2013-2014, James Hardie Building Products, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
````

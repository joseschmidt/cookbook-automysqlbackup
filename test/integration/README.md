README
======

This document describes how to use chef-zero to access data from the `test/integration` directory.


Data Bags
---------

Display contents of `encrypted/qa` data bag:

````bash
$ knife data bag show encrypted qa --local-mode --format json --secret-file encrypted_data_bag_secret

WARN: No cookbooks directory found at or above current directory.  Assuming /.../cookbook-automysqlbackup/test/integration.
{
  "id": "qa",
  "automysqlbackup": "automysqlbackup_password",
  "mysql": {
    "root": "root_password"
  }
}
````

Edit `encrypted/qa` data bag (opens separate editor window):
````bash
$ knife data bag edit encrypted qa --local-mode --secret-file encrypted_data_bag_secret
````

Create and store new `encrypted_data_bag_secret` (**WARNING**: modifications to `encrypted_data_bag_secret` will render existing encrypted data bags unreadable):

````bash
$ openssl rand -base64 512 | tr -d '\r\n' > encrypted_data_bag_secret
````

Create new `encrypted/example` data bag (opens separate editor window):
````bash
$ knife data bag create encrypted example --local-mode --secret-file encrypted_data_bag_secret
````


Environments
------------

Display contents of `qa` environment:

````bash
$ knife environment show qa --local-mode --format json

WARN: No cookbooks directory found at or above current directory.  Assuming /.../cookbook-automysqlbackup/test/integration.
{
  "name": "qa",
  "description": "QA environment for test-kitchen",
  "cookbook_versions": {
  },
  "json_class": "Chef::Environment",
  "chef_type": "environment",
  "default_attributes": {
  },
  "override_attributes": {
  }
}
````

Edit `qa` environment (opens separate editor window):
````bash
$ knife environment edit qa --local-mode
````

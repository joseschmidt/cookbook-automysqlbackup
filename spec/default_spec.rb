# coding: utf-8
require 'spec_helper'

describe 'automysqlbackup::default' do
  before do
    Chef::Sugar::DataBag.stub(:encrypted_data_bag_item).and_return(
      'automysqlbackup' => 'automysqlbackup_password',
      'mysql' => {
        'root' => 'root_password'
      }
    )
  end # before

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      # create a new environment
      env = Chef::Environment.new
      env.name 'qa'

      # stub the node to return this environment
      node.stub(:chef_environment).and_return(env.name)

      # stub any calls to Environment.load to return this environment
      Chef::Environment.stub(:load).and_return(env)

      # override cookbook attributes
      node.set['automysqlbackup'] = {
        'backup_dir' => '/var/tmp/backup_dir',
        'conf_dir' => '/var/tmp/conf_dir',
        'conf_file' => 'automysqlbackup_conf_file'
      }

      # required for build-essential cookbook on travis-ci
      node.set['platform_family'] = 'rhel'
    end.converge(described_recipe)
  end # let

  it 'includes recipe mysql::ruby' do
    expect(chef_run).to include_recipe('mysql::ruby')
  end # it

  it 'includes recipe chef-sugar' do
    expect(chef_run).to include_recipe('chef-sugar')
  end # it

  it 'creates /etc/cron.daily/automysqlbackup.sh owned by root:root' do
    file = '/etc/cron.daily/automysqlbackup.sh'
    expect(chef_run).to create_cookbook_file(file)
      .with(:owner => 'root', :group => 'root')
  end # it

  it 'creates directory /var/tmp/conf_dir' do
    dir = '/var/tmp/conf_dir'
    expect(chef_run).to create_directory(dir)
      .with(:owner => 'root', :group => 'root')
  end # it

  it 'creates /var/.../automysqlbackup_conf_file owned by root:root' do
    file = '/var/tmp/conf_dir/automysqlbackup_conf_file'
    expect(chef_run).to render_file(file).with_content('automysqlbackup')
    expect(chef_run).to render_file(file)
      .with_content('automysqlbackup_password')
    expect(chef_run).to render_file(file).with_content('/var/tmp/backup_dir')
    expect(chef_run).to create_template(file)
      .with(:owner => 'root', :group => 'root')
  end # it

  it 'creates directory /var/tmp/backup_dir' do
    dir = '/var/tmp/backup_dir'
    expect(chef_run).to create_directory(dir)
      .with(:owner => 'root', :group => 'root')
  end # it

  it 'grants privileges to user automysqlbackup@localhost' do
    pending 'grants privileges to user automysqlbackup@localhost'
  end # it

end # describe

# encoding: utf-8
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
      node.set['automysqlbackup']['backup_dir'] = '/var/tmp/backup_dir'
      node.set['automysqlbackup']['conf_dir'] = '/var/tmp/conf_dir'
      node.set['automysqlbackup']['conf_file'] = 'automysqlbackup_conf_file'

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

  describe '/etc/cron.daily/automysqlbackup.sh' do
    it 'creates file with expected owner, group' do
      expect(chef_run).to create_cookbook_file(subject)
        .with(:owner => 'root', :group => 'root')
    end # it
  end # describe

  describe '/var/tmp/conf_dir' do
    it 'creates directory with expected owner, group' do
      expect(chef_run).to create_directory(subject)
        .with(:owner => 'root', :group => 'root')
    end # it
  end # describe

  describe '/var/tmp/conf_dir/automysqlbackup_conf_file' do
    it 'renders file with expected USERNAME' do
      expect(chef_run).to render_file(subject)
        .with_content('USERNAME=automysqlbackup')
    end # it

    it 'renders file with expected PASSWORD' do
      expect(chef_run).to render_file(subject)
        .with_content('PASSWORD=automysqlbackup_password')
    end # it

    it 'renders file with expected BACKUPDIR' do
      expect(chef_run).to render_file(subject)
        .with_content('BACKUPDIR="/var/tmp/backup_dir"')
    end # it

    it 'creates template with expected owner, group' do
      expect(chef_run).to create_template(subject)
        .with(:owner => 'root', :group => 'root')
    end # it
  end # describe

  describe '/var/tmp/backup_dir' do
    it 'creates directory with expected owner, group' do
      expect(chef_run).to create_directory(subject)
        .with(:owner => 'root', :group => 'root')
    end # it
  end # describe

  describe 'automysqlbackup' do
    it 'grants user access to mysql database with expected options' do
      expect(chef_run).to grant_mysql_database_user(subject)
        .with_username(subject)
        .with_host('localhost')
        .with_password("#{subject}_password")
        .with_privileges(['SELECT', 'LOCK TABLES'])
    end # it
  end # describe

end # describe

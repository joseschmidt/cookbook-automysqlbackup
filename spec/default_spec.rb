# coding: utf-8
require 'spec_helper'

describe 'automysqlbackup::default' do
  before do
    Chef::EncryptedDataBagItem.stub(:load).and_return({
      'automysqlbackup' => 'automysqlbackup_password',
      'mysql' => {
        'root' => 'root_password'
      },
    })
    Chef::EncryptedDataBagItem.stub(:load_secret).and_return('sekret')
  end # before

  let (:chef_run) do
    ChefSpec::Runner.new do |node|
      env = Chef::Environment.new
      env.name 'qa'
      node.stub(:chef_environment).and_return env.name
      Chef::Environment.stub(:load).and_return env
      node.set['automysqlbackup'] = {
        'backup_dir' => '/var/tmp/backup_dir',
        'conf_dir' => '/var/tmp/conf_dir',
        'conf_file' => 'automysqlbackup_conf_file'
      }
      node.set['platform_family'] = 'rhel'
    end.converge(described_recipe)
  end # let

  it 'should include recipe mysql::ruby' do
    expect(chef_run).to include_recipe('mysql::ruby')
  end # it

  it 'should include recipe helpers' do
    expect(chef_run).to include_recipe('helpers')
  end # it

  it 'should create /etc/cron.daily/automysqlbackup.sh owned by root:root' do
    file = '/etc/cron.daily/automysqlbackup.sh'
    expect(chef_run).to create_cookbook_file(file)
    expect(chef_run.cookbook_file(file).owner).to eq('root')
    expect(chef_run.cookbook_file(file).group).to eq('root')
  end # it

  it 'should create directory /var/tmp/conf_dir' do
    dir = '/var/tmp/conf_dir'
    expect(chef_run).to create_directory(dir)
    expect(chef_run.directory(dir).owner).to eq('root')
    expect(chef_run.directory(dir).group).to eq('root')
  end # it

  it 'should create /var/tmp/conf_dir/automysqlbackup_conf_file owned by root:root' do
    file = '/var/tmp/conf_dir/automysqlbackup_conf_file'
    expect(chef_run).to render_file(file).with_content('automysqlbackup')
    expect(chef_run).to render_file(file).with_content('automysqlbackup_password')
    expect(chef_run).to render_file(file).with_content('/var/tmp/backup_dir')
    expect(chef_run.template(file).owner).to eq('root')
    expect(chef_run.template(file).group).to eq('root')
  end # it

  it 'should create directory /var/tmp/backup_dir' do
    dir = '/var/tmp/backup_dir'
    expect(chef_run).to create_directory(dir)
    expect(chef_run.directory(dir).owner).to eq('root')
    expect(chef_run.directory(dir).group).to eq('root')
  end # it

  it 'should grant privileges to user automysqlbackup@localhost' do
    pending 'should grant privileges to user automysqlbackup@localhost'
  end # it

end # describe

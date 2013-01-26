require 'chefspec'
require 'fauxhai'
require 'librarian/chef/integration/knife'

describe 'automysqlbackup::default' do
  before do
    Fauxhai.mock(:environment => 'qa') do |node|
      node['automysqlbackup'] = {
        'backup_dir' => '/var/tmp/backup_dir',
        'conf_dir' => '/var/tmp/conf_dir',
        'conf_file' => 'automysqlbackup_conf_file'
      }
    end # Fauxhai.mock(:environment => 'qa')
    
    Chef::EncryptedDataBagItem.stub(:load).and_return({
      'automysqlbackup' => 'automysqlbackup_password',
      'mysql' => {
        'root' => 'root_password'
      },
    })
  end # before
  
  opts = { :cookbook_path => Librarian::Chef.install_path.to_s }
  let (:chef_run) do
    ChefSpec::ChefRunner.new(opts).converge 'automysqlbackup::default'
  end # let (:chef_run)
  
  it 'should include recipe mysql::ruby' do
    chef_run.should include_recipe 'mysql::ruby'
  end # it 'should include recipe mysql::ruby'
  
  it 'should include recipe helpers' do
    chef_run.should include_recipe 'helpers'
  end # it 'should include recipe helpers'
  
  it 'should create /etc/cron.daily/automysqlbackup.sh owned by root:root' do
    file = '/etc/cron.daily/automysqlbackup.sh'
    chef_run.should create_cookbook_file file
    chef_run.cookbook_file(file).should be_owned_by 'root', 'root'
  end # it 'should create /etc/cron.daily/automysqlbackup.sh...'
  
  it 'should create directory /var/tmp/conf_dir' do
    dir = '/var/tmp/conf_dir'
    chef_run.should create_directory dir
    chef_run.directory(dir).should be_owned_by 'root', 'root'
  end # it 'should create directory /var/tmp/conf_dir'
  
  it 'should create /var/tmp/conf_dir/automysqlbackup_conf_file owned by root:root' do
    file = '/var/tmp/conf_dir/automysqlbackup_conf_file'
    chef_run.should create_file_with_content file, 'automysqlbackup'
    chef_run.should create_file_with_content file, 'automysqlbackup_password'
    chef_run.should create_file_with_content file, '/var/tmp/backup_dir'
    chef_run.template(file).should be_owned_by 'root', 'root'
  end # it 'should create /var/tmp/conf_dir/automysqlbackup_conf_file...'
  
  it 'should create directory /var/tmp/backup_dir' do
    dir = '/var/tmp/backup_dir'
    chef_run.should create_directory dir
    chef_run.directory(dir).should be_owned_by 'root', 'root'
  end # it 'should create directory /var/tmp/backup_dir'
  
  it 'should grant privileges to user automysqlbackup@localhost' do
    pending 'should grant privileges to user automysqlbackup@localhost'
  end # it 'should grant privileges to user automysqlbackup@localhost'
  
end # describe 'automysqlbackup::default'

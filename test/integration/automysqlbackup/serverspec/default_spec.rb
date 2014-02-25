# encoding: utf-8
require 'spec_helper'

describe 'automysqlbackup::default' do
  describe file('/etc/cron.daily/automysqlbackup.sh') do
    it 'is file' do
      expect(subject).to be_file
    end # it

    it 'is owned by root' do
      expect(subject).to be_owned_by('root')
    end # it

    it 'is in group root' do
      expect(subject).to be_grouped_into('root')
    end # it

    it 'is mode 755' do
      expect(subject).to be_mode(755)
    end # it

    it 'includes expected content' do
      expect(subject.content).to include('MySQL Backup Script')
    end # it
  end # describe

  describe file('/etc/automysqlbackup-qa') do
    it 'is directory' do
      expect(subject).to be_directory
    end # it

    it 'is owned by root' do
      expect(subject).to be_owned_by('root')
    end # it

    it 'is in group root' do
      expect(subject).to be_grouped_into('root')
    end # it

    it 'is mode 755' do
      expect(subject).to be_mode(755)
    end # it
  end # describe

  describe file('/etc/automysqlbackup-qa/automysqlbackup-qa.conf') do
    it 'is file' do
      expect(subject).to be_file
    end # it

    it 'is owned by root' do
      expect(subject).to be_owned_by('root')
    end # it

    it 'is in group root' do
      expect(subject).to be_grouped_into('root')
    end # it

    it 'is mode 600' do
      expect(subject).to be_mode(600)
    end # it

    it 'includes expected USERNAME' do
      expect(subject.content).to include('USERNAME=automysqlbackup-qa')
    end # it

    it 'includes expected PASSWORD' do
      expect(subject.content).to include('PASSWORD=automysqlbackup_password')
    end # it

    it 'includes expected BACKUPDIR' do
      expect(subject.content).to include('BACKUPDIR="/var/backup/db-qa"')
    end # it
  end # describe

  describe file('/var/backup/db-qa') do
    it 'is directory' do
      expect(subject).to be_directory
    end # it

    it 'is owned by root' do
      expect(subject).to be_owned_by('root')
    end # it

    it 'is in group root' do
      expect(subject).to be_grouped_into('root')
    end # it

    it 'is mode 700' do
      expect(subject).to be_mode(700)
    end # it
  end # describe

  cmd = []
  cmd << 'mysql'
  cmd << '--user automysqlbackup'
  cmd << '--password=automysqlbackup_password'
  cmd << '--database mysql'
  cmd << '--execute="show grants for automysqlbackup@localhost;"'
  describe command(cmd.join(' ')) do
    it 'returns exit status 0' do
      expect(subject).to return_exit_status(0)
    end # it

    it 'returns expected GRANT statement' do
      expect(subject.stdout).to include(
        "GRANT SELECT, LOCK TABLES ON *.* TO 'automysqlbackup'@'localhost'"
    )
    end # it
  end # describe

end # describe

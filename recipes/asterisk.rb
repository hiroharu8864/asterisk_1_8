#
# Cookbook Name:: asterisk_1_8
# Recipe:: asterisk
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
source_dir="/usr/local/src"
asteriskfile="asterisk-1.8.9.0"

cookbook_file "#{source_dir}/#{asteriskfile}.tar.gz" do
  mode 0644
end

%w{gcc-c++ ncurses-devel openssl-devel libxml2-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

template "yum.conf" do
  path "/etc/yum.conf"
  source "yum.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

execute "yum-update" do
  user "root"
  command "/usr/bin/yum -y update"
  action :run
end

script "unzip_asterisk" do
  not_if { File.exists?("/etc/init.d/asterisk") }
  interpreter "bash"
  user "root"
  code <<-EOL
    cd #{source_dir}
    tar xvfz #{asteriskfile}.tar.gz
  EOL
end


script "install_asterisk" do
  not_if { File.exists?("/etc/init.d/asterisk") }
  interpreter "bash"
  user "root"
  user "root"
  code <<-EOL
    cd #{source_dir}/#{asteriskfile}
    ./configure
    make
    make install
    make samples
    make config
  EOL
end

user "asterisk" do
  uid 5060
  home "/var/lib/asterisk"
  shell "/sbin/nologin"
  password nil
  supports :manage_home => false
end

group "asterisk" do
  gid 5060
  members ['asterisk']
  action :create
end

template "asterisk.conf" do
  path "/etc/asterisk/asterisk.conf"
  source "asterisk.conf.erb"
  owner "asterisk"
  group "asterisk"
  mode 0644
end

template "logger.conf" do
  path "/etc/asterisk/logger.conf"
  source "logger.conf.erb"
  owner "asterisk"
  group "asterisk"
  mode 0644
end

script "chown_directory" do
  only_if { File.exists?("/etc/asterisk") }
  interpreter "bash"
  code <<-EOL
    chown -R asterisk:asterisk /etc/asterisk
    chown -R asterisk:asterisk /var/lib/asterisk
    chown -R asterisk:asterisk /var/spool/asterisk
    chown -R asterisk:asterisk /var/run/asterisk
    chown -R asterisk:asterisk /var/log/asterisk
  EOL
end

service "asterisk" do
  supports :restart => true, :reload => true
  action [ :start, :enable]
  subscribes :restart, "template[sip.conf]"
  subscribes :restart, "template[extensions.conf]"
end


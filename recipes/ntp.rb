#
# Cookbook Name:: asterisk_1_8
# Recipe:: ntp
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "ntp" do
  action :install
end

service "ntpd" do
  action [ :enable, :start ]
end

template "/etc/ntp.conf" do
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[ntpd]'
end

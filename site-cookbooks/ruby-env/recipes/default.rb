#
# Cookbook Name:: ruby-env
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'yum'
%w{git openssl-devel sqlite-devel}.each do |pkg|
  package pkg do
    action :install
    options '--enablerepo=epel,remi'
  end
end

git "/home/#{node['ruby-env']['user']}/.rbenv" do
  repository node["ruby-env"]["rbenv_url"]
  action :sync
  user node['ruby-env']['user']
  group node['ruby-env']['group']
end

template ".bash_profile" do
  source ".bash_profile.erb"
  path "/home/#{node['ruby-env']['user']}/.bash_profile"
  mode 0644
  owner node['ruby-env']['user']
  group node['ruby-env']['group']
  not_if "grep rbenv ~/.bash_profile", :environment => { :'HOME' => "/home/#{node['ruby-env']['user']}" }
end

# Cookbook:: lamp_stack
# Recipe:: default
#
# Copyright:: 2018
chef_gem("chef-vault")
require 'chef-vault'

vault_data = ChefVault::Item.load("newchefvault", "database")
vault_dataenc = ChefVault::Item.load("newchefvault", "databaseenc")
vault_enc=vault_dataenc['encrypt']
vault_data['db_password']
vault_dataenc['encrypt']

user "chefusernew" do
  file "/home/vagrant/id_rsa" do
    content vault_dataenc['encrypt']
    owner "vagrant"
    group "vagrant"
    mode 0600
  end
end
user "chefuser" do
  file "/home/vagrant/id_rsa" do
    content vault_data[vault_enc]
    owner "vagrant"
    group "vagrant"
    mode 0600
  end
end

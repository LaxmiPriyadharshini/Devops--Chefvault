

Vagrant.configure("2") do |config|


  config.vm.define :chef_server do |server_config|
    server_config.vm.box = "ubuntu/bionic64"
    server_config.vm.hostname = "chefserver"
    server_config.vm.network :private_network, ip: "10.0.1.15"
    server_config.vm.network :forwarded_port, guest: 22, host: 9194
    server_config.ssh.guest_port = 9195
    server_config.ssh.username = "vagrant"
    server_config.ssh.password = "vagrant"
    server_config.vm.network "forwarded_port", guest: 80, host: 8181

    server_config.vm.provision "shell", inline: <<-EOC
      echo "10.0.1.15 chefserver" >> /etc/hosts
      echo "10.0.1.16 chefnode" >> /etc/hosts
      cd /home/vagrant

      sudo apt-get update
      wget -q -O chef-dk.deb https://packages.chef.io/files/stable/chefdk/3.0.36/ubuntu/16.04/chefdk_3.0.36-1_amd64.deb
      sudo dpkg -i chef-dk.deb
      wget -q -O chef-server.deb https://packages.chef.io/files/stable/chef-server/12.17.33/ubuntu/16.04/chef-server-core_12.17.33-1_amd64.deb
      sudo dpkg -i chef-server.deb

      chef-server-ctl reconfigure
      sudo chef-server-ctl user-create chefuser "chefadmin" 'lsureshk@andrew.cmu.edu' 'adminpass' --filename /vagrant/chefuser.pem
      sudo chef-server-ctl user-create chefusernew "chefadmin" "new" 'lsureshk@andrew.cmu.edu' 'adminpass' --filename /vagrant/chefusernew.pem

      sudo chef-server-ctl org-create 4thcoffee "Fourth Coffee, Inc" --association_user chefuser --filename /vagrant/4thcoffee.pem
      chef-server-ctl org-user-add 4thcoffee chefusernew

      sudo chef-server-ctl install chef-manage
      sudo chef-server-ctl reconfigure
      sudo chef-manage-ctl reconfigure --accept-license

      mkdir /home/vagrant/.chef/
      /bin/cp /vagrant/knife.rb /home/vagrant/.chef/
      knife ssl fetch
      knife cookbook upload lamp_stack
    EOC
  end

  config.vm.define :chef_node do |node_config|
  	node_config.vm.box = "ubuntu/bionic64"
  	node_config.vm.hostname = "chefnode"
    node_config.vm.network :private_network, ip: "10.0.1.16"
    node_config.vm.network :forwarded_port, guest: 22, host: 9195
    node_config.ssh.guest_port = 9195
    node_config.ssh.username = "vagrant"
    node_config.ssh.password = "vagrant"
    node_config.vm.network "forwarded_port", guest: 8080, host: 8080

    node_config.vm.provision "shell", inline: <<-EOC
      echo "10.0.1.15 chefserver" >> /etc/hosts
      echo "10.0.1.16 chefnode" >> /etc/hosts
      cd /home/vagrant

      sudo apt-get update
      sudo apt-get install -y default-jdk
      wget -q -O chef-dk.deb https://packages.chef.io/files/stable/chefdk/3.0.36/ubuntu/16.04/chefdk_3.0.36-1_amd64.deb
      sudo dpkg -i chef-dk.deb
      wget -q -O chef-client.deb https://packages.chef.io/files/stable/chef/14.2.0/ubuntu/16.04/chef_14.2.0-1_amd64.deb
      sudo dpkg -i chef-client.deb

      mkdir /home/vagrant/.chef/
      /bin/cp /vagrant/knife.rb /home/vagrant/.chef/
      knife ssl fetch
      knife role from file /vagrant/lamp_stack/roles/chefnode.json
      knife bootstrap chefnode -x vagrant -P vagrant --sudo --node-name chefnode
      knife node run_list add chefnode 'role[chefnode]'

      sudo chef-client
    EOC
  end

end

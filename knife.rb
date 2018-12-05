# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "admin"
client_key               "/vagrant/chefuser.pem"
chef_server_url          "https://chefserver/organizations/4thcoffee"
cookbook_path            ["/vagrant/lamp_stack/cookbooks"]

Vagrant.configure("2") do |config|
config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
config.vm.box = "curtismitchell/centos7.0"
config.ssh.insert_key = false
config.vm.box_url = "https://atlas.hashicorp.com/curtismitchell/boxes/centos7.0"
config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 3072] # RAM allocated to each VM
  end


 

config.vm.define :ambariserver do |ambariserver|
ambariserver.vm.hostname = "c6405.ambari.apache.org"
ambariserver.vm.network :private_network, ip: "192.168.64.105"
 ambariserver.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "apache"
         end
end


config.vm.define :hadoop do |hadoop|
config.vm.synced_folder "/home/alexander/ambari/data", "/vagrant_data"
hadoop.vm.hostname = "c6406.ambari.apache.org"
hadoop.vm.network :private_network, ip: "192.168.64.106"
    hadoop.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "agent"
        end
  end
end

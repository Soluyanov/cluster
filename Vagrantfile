Vagrant.configure("2") do |config|
config.vm.box = "centos6.4"
config.ssh.insert_key = false
config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130427.box"
config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 3072] # RAM allocated to each VM
  end


  config.vm.provision "chef_solo" do |chef|

config.vm.define :ambariserver do |ambariserver|
ambariserver.vm.hostname = "c6405.ambari.apache.org"
ambariserver.vm.network :private_network, ip: "192.168.64.105"
    chef.add_recipe "apache"
  end


config.vm.define :hadoop do |hadoop|
config.vm.synced_folder "/home/alexander/ambari/data", "/vagrant_data"
hadoop.vm.hostname = "c6406.ambari.apache.org"
hadoop.vm.network :private_network, ip: "192.168.64.106"
    chef.add_recipe "agent"
  end


end
end


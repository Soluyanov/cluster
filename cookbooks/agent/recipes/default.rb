

execute 'add repo' do
command "wget -nv http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.1.0/ambari.repo -O /etc/yum.repos.d/ambari.repo"
end

%w(ambari-agent).each do |pack|
  package pack do
    action :install
  end
end


ambari_server_fqdn = 'ambariserver.ambari.apache.org'
  


execute 'add hosts' do
command "echo '192.168.64.105 c6405.ambari.apache.org c6405' >> /etc/hosts"
end

execute 'add hosts' do
command "echo '192.168.64.106 c6406.ambari.apache.org c6406' >> /etc/hosts"
end

execute 'alternatives configured confdir' do
command "sed -i 's/localhost/c6405.ambari.apache.org/g' /etc/ambari-agent/conf/ambari-agent.ini"
end

service 'ambari-agent' do
  action [:enable, :start]
end

service 'iptables' do
  action [:disable, :stop]
end


# blueprint


if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  ambari_server_fqdn = 'c6405.ambari.apache.org'
end



execute 'Init Blueprints' do
  command "curl -u admin:admin -i -H 'X-Requested-By: ambari' -X POST -d @/vagrant_data/blueprint.json http://c6405.ambari.apache.org:8080/api/v1/blueprints/blueprint"
end

execute 'Init Cluster' do
  command "curl -u admin:admin -i -H 'X-Requested-By: ambari' -X POST -d @/vagrant_data/template.json http://c6405.ambari.apache.org:8080/api/v1/clusters/mycluster"
end

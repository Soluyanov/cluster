

yum_repository 'ambari' do
  description "Public ambari repo"
  baseurl "http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.0.0"
  gpgkey 'http://public-repo-1.hortonworks.com/ambari/centos7/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins'
  action :create
end

package 'ambari-agent'

 
execute 'alternatives configured confdir' do
command "sed -i 's/localhost/c6405.ambari.apache.org/g' /etc/ambari-agent/conf/ambari-agent.ini"
end

service 'ambari-agent' do
  action [:enable, :start]
end

execute 'enable firewalld' do
command "systemctl enable firewalld"
end

execute 'start firewalld' do
command "systemctl start firewalld"
end

execute 'add port 8080' do
command "firewall-cmd --add-port=8080/tcp"
end

execute 'add port 8440' do
command "firewall-cmd --add-port=8440/tcp"
end
execute 'add port 8441' do
command "firewall-cmd --add-port=8441/tcp"
end


http_request 'posting data' do
  action :post
  url 'http://c6405.ambari.apache.org:8080/api/v1/blueprints/blueprint'
  message (File.read("/vagrant_data/blueprint.json"))
  headers({'AUTHORIZATION' => "Basic #{
    Base64.encode64('admin:admin')}",
    'X-Requested-By' => 'ambari'
   })
not_if 'curl -u admin:admin http://c6405.ambari.apache.org:8080/api/v1/blueprints | grep ""blueprint_name" : "blueprint""'
end

http_request 'Init Cluster' do
  action :post
  url 'http://c6405.ambari.apache.org:8080/api/v1/clusters/mycluster'
  message (File.read("/vagrant_data/template.json"))
  headers({'AUTHORIZATION' => "Basic #{
    Base64.encode64('admin:admin')}",
    'X-Requested-By' => 'ambari'
    })
not_if 'curl -u admin:admin http://c6405.ambari.apache.org:8080/api/v1/clusters | grep ""cluster_name" : "mycluster""'
end

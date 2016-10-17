

yum_repository 'ambari' do
  description "Public ambari repo"
  baseurl "http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.0.0"
  gpgkey 'http://public-repo-1.hortonworks.com/ambari/centos7/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins'
  action :create
end

package 'ambari-agent'

 
#execute 'alternatives configured confdir' do


ambari_server_fqdn = node['agent'][:serverhost]


template "/etc/ambari-agent/conf/ambari-agent.ini" do
  source "ambari-agent.ini.erb"
  mode 0755
  user "root"
  group "root"
  variables({
    ambari_server_fqdn: ambari_server_fqdn
  })
end

service 'ambari-agent' do
  action [:enable, :start]
end

service 'firewalld' do
  action [:enable, :start]
end


firewalld_port '8080/tcp'
firewalld_port '8440/tcp'
firewalld_port '8441/tcp'



http_request 'posting data' do
  action :post
  url "http://#{ambari_server_fqdn}:8080/api/v1/blueprints/blueprint"
  message (File.read("/vagrant_data/blueprint.json"))
  headers({'AUTHORIZATION' => "Basic #{
    Base64.encode64('admin:admin')}",
    'X-Requested-By' => 'ambari'
   })
not_if 'curl -u admin:admin #{ambari_server_fqdn}:8080/api/v1/blueprints | grep ""blueprint_name" : "blueprint""'
end

http_request 'Init Cluster' do
  action :post
  url "http://#{ambari_server_fqdn}:8080/api/v1/clusters/mycluster"
  message (File.read("/vagrant_data/template.json"))
  headers({'AUTHORIZATION' => "Basic #{
    Base64.encode64('admin:admin')}",
    'X-Requested-By' => 'ambari'
    })
not_if 'curl -u admin:admin #{ambari_server_fqdn}:8080/api/v1/clusters | grep ""cluster_name" : "mycluster""'
end

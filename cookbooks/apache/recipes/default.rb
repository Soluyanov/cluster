


yum_repository 'ambari' do
  description "Public ambari repo"
  baseurl "http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.0.0"
  gpgkey 'http://public-repo-1.hortonworks.com/ambari/centos7/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins'
  action :create
end


service 'firewalld' do
  action [:enable, :start]
end



firewalld_port '8080/tcp'
firewalld_port '8440/tcp'
firewalld_port '8441/tcp'


package 'ambari-server'

execute "setup ambari-server" do
  command "ambari-server setup -s"
  not_if "ambari-server status | grep 'Stale PID File'"
end

service "ambari-server" do
  action :start
end



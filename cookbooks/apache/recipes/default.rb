


yum_repository 'ambari' do
  description "Public ambari repo"
  baseurl "http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.0.0"
  gpgkey 'http://public-repo-1.hortonworks.com/ambari/centos7/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins'
  action :create
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

package 'ambari-server'

execute "setup ambari-server" do
  command "ambari-server setup -s"
not_if "rpm -qa | grep -qx 'ambari-server'"
end

service "ambari-server" do
  action :start
end



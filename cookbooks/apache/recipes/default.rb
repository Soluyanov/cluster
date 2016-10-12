

execute 'add hosts' do
command "wget -nv http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.1.0/ambari.repo -O /etc/yum.repos.d/ambari.repo"
end
execute 'add hosts' do
command "echo '192.168.64.105 c6405.ambari.apache.org c6405' >> /etc/hosts"
end

execute 'add hosts' do
command "echo '192.168.64.106 c6406.ambari.apache.org c6406' >> /etc/hosts"
end

service 'iptables' do
  action [:disable, :stop]
end

execute "install ambari-server" do
  command "yum install ambari-server -y"
end

execute "setup ambari-server" do
  command "ambari-server setup -s"
end


execute "start ambari-server" do
  command "ambari-server start"
end

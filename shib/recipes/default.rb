node[:deploy].each do |app_name, deploy|

  script "install_nothing" do
    interpreter "bash"
    user "root"
    code <<-EOH
    apt-get install curl
	curl -k -O http://pkg.switch.ch/switchaai/SWITCHaai-swdistrib.asc
	apt-key add SWITCHaai-swdistrib.asc
	echo 'deb http://pkg.switch.ch/switchaai/ubuntu precise main' | sudo tee /etc/apt/sources.list.d/SWITCHaai-swdistrib.list > /dev/null
	apt-get update
	apt-get install -f shibboleth -y
    EOH
  end
end

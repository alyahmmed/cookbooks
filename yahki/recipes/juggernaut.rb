node[:deploy].each do |app_name, deploy|

  %w{redis-server nodejs npm}.each do |pkg|
  	package pkg do
  	end
  end

  script "install_juggernaut" do
    interpreter "bash"
    user "root"
    code <<-EOH
    npm config set registry http://registry.npmjs.org/
    npm install -g juggernaut
    EOH
  end

  template "juggernaut_init" do
    source "juggernaut.init.erb"
    path "/etc/init.d/juggernaut"
  end

  template "juggernaut_conf" do
    source "juggernaut.conf.erb"
    path "/etc/init/juggernaut.conf"
  end

  script "juggernaut_service" do
    interpreter "bash"
    user "root"
    code <<-EOH
    id -u juggernaut &>/dev/null || adduser --system --no-create-home --disabled-login --disabled-password --group juggernaut
    chmod +x /etc/init.d/juggernaut
    update-rc.d -f juggernaut defaults &>/dev/null
    service juggernaut start
    EOH
  end
end

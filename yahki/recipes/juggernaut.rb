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
    service juggernaut restart
    EOH
  end

  template "juggernaut-rails" do
    source "juggernaut-rails.erb"
    path "/usr/local/bin/juggernaut-rails"
  end

  template "juggernaut-rails_init" do
    source "juggernaut-rails.init.erb"
    path "/etc/init.d/juggernaut-rails"
  end

  template "juggernaut-rails_conf" do
    source "juggernaut-rails.conf.erb"
    path "/etc/init/juggernaut-rails.conf"
  end

  script "juggernaut-rails_service" do
    interpreter "bash"
    user "root"
    code <<-EOH
    id -u juggernaut-rails &>/dev/null || adduser --system --no-create-home --disabled-login --disabled-password --group juggernaut-rails
    chmod +x /etc/init.d/juggernaut-rails
    update-rc.d -f juggernaut-rails defaults &>/dev/null
    EOH
  end
end

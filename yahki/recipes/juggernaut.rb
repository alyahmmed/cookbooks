node[:deploy].each do |app_name, deploy|

  %w{nodejs npm}.each do |pkg|
  	package pkg do
  	end
  end

  #################
  # Redis service
  #################

  script "install_redis2.8" do
    interpreter "bash"
    user "root"
    code <<-EOH
    mkdir /opt/redis && cd /opt/redis
    wget http://download.redis.io/releases/redis-2.8.19.tar.gz
    tar xzf redis-2.8.19.tar.gz && cd redis-2.8.19 && make
    ln -fs /opt/redis/redis-2.8.19/src/redis-server /usr/bin/redis-server
    ln -fs /opt/redis/redis-2.8.19/src/redis-cli /usr/bin/redis-cli
    mkdir ­p /etc/redis >& /dev/null
    cp -f /opt/redis/redis-2.8.19/redis.conf /etc/redis/redis.conf
    EOH
  end

  template "redis_init" do
    source "redis.init.erb"
    path "/etc/init.d/redis-server"
  end

  template "redis_conf" do
    source "redis.conf.erb"
    path "/etc/init/redis-server.conf"
  end

  script "redis_service" do
    interpreter "bash"
    user "root"
    code <<-EOH
    id -u redis &>/dev/null || adduser --system --no-create-home --disabled-login --disabled-password --group redis
    chmod +x /etc/init.d/redis-server
    update-rc.d -f redis-server defaults &>/dev/null
    service redis-server restart
    EOH
  end

  #################
  # Juggernaut service
  #################

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

  #################
  # Rails gem for Juggernaut Yahki listener service
  #################

  gem_package 'rails' do
    options("-v 3.2.0")
    action :install
  end

  #################
  # Juggernaut Yahki listener service
  #################

  template "juggernaut-yahki" do
    source "juggernaut-yahki.erb"
    path "/usr/local/bin/juggernaut-yahki"
  end

  template "juggernaut-yahki_init" do
    source "juggernaut-yahki.init.erb"
    path "/etc/init.d/juggernaut-yahki"
  end

  template "juggernaut-yahki_conf" do
    source "juggernaut-yahki.conf.erb"
    path "/etc/init/juggernaut-yahki.conf"
  end

  script "juggernaut-yahki_service" do
    interpreter "bash"
    user "root"
    code <<-EOH
    id -u juggernaut-yahki &>/dev/null || adduser --system --no-create-home --disabled-login --disabled-password --group juggernaut-yahki
    chmod +x /etc/init.d/juggernaut-yahki
    update-rc.d -f juggernaut-yahki defaults &>/dev/null
    EOH
  end
end

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

  script "run_juggernaut" do
    interpreter "bash"
    user "root"
    code <<-EOH
    redis-server
    juggernaut
    EOH
  end
end

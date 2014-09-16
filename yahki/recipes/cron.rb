node[:deploy].each do |app_name, deploy|

  cron "index_users" do
	minute "*/5"
	command "wget -q http://#{node[:opsworks][:instance][:ip]}/welcome?index_users"
  end
  
  cron "index_users" do
	minute "*/5"
	command "wget -q http://#{node[:opsworks][:instance][:ip]}/welcome?index_curations"
  end
  
  cron "index_users" do
	minute "*/12"
	command "wget -q http://#{node[:opsworks][:instance][:ip]}/welcome?optimize_index"
  end
end

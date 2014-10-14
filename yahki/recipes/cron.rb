node[:deploy].each do |app_name, deploy|

  cron "index_users" do
	minute "*/5"
	command "wget -O ./cron_job.txt -q http://#{node[:opsworks][:instance][:ip]}/index_users"
  end
  
  cron "index_curations" do
	minute "*/5"
	command "wget -O ./cron_job.txt -q http://#{node[:opsworks][:instance][:ip]}/index_curations"
  end
  
  cron "optimize_index" do
	minute "*/12"
	command "wget -O ./cron_job.txt -q http://#{node[:opsworks][:instance][:ip]}/optimize_index"
  end
end

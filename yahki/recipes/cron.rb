node[:deploy].each do |app_name, deploy|
  
  script "cron_clean" do
	interpreter "bash"
	user "root"
	code <<-EOH
	mkdir /srv/www/#{app_name}/current/tmp/time
	chmod 777 /srv/www/#{app_name}/current/tmp/time
	EOH
  end 

  cron "job_name" do
	minute "*/5"
	command "cd /srv/www/#{app_name}/current/tmp/time && touch $RANDOM"
  end
end

node[:deploy].each do |app_name, deploy|

  cron "job_name" do
	minute "*/5"
	command "cd /srv/www/#{app_name}/current/tmp/time && touch $RANDOM"
end
end

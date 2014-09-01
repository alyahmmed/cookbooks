node[:deploy].each do |app_name, deploy|
	
	include_recipe 'deploy::default'
  
	script "deploy_clean" do
		interpreter "bash"
		user "root"
		code <<-EOH
		sed -i "10i ShibUseHeaders On" /etc/apache2/sites-available/#{app_name}.conf
		sed -i "10i SetHandler shib" /etc/apache2/sites-available/#{app_name}.conf
		sed -i "10i Require shibboleth" /etc/apache2/sites-available/#{app_name}.conf
		sed -i "10i ShibRequireSession Off" /etc/apache2/sites-available/#{app_name}.conf
		sed -i "10i AuthType shibboleth" /etc/apache2/sites-available/#{app_name}.conf
		service apache2 restart
		EOH
	end  
	
	script "deploy_clean_https" do
		if node[:deploy][app_name][:ssl_support]
			interpreter "bash"
			user "root"
			code <<-EOH
			sed -i "70i ShibUseHeaders On" /etc/apache2/sites-available/#{app_name}.conf
			sed -i "70i SetHandler shib" /etc/apache2/sites-available/#{app_name}.conf
			sed -i "70i Require shibboleth" /etc/apache2/sites-available/#{app_name}.conf
			sed -i "70i ShibRequireSession Off" /etc/apache2/sites-available/#{app_name}.conf
			sed -i "70i AuthType shibboleth" /etc/apache2/sites-available/#{app_name}.conf
			service apache2 restart
			EOH
		end
	end

	template "shibboleth2" do
		source "shibboleth2.xml.erb"
		path "/etc/shibboleth/shibboleth2.xml"
		variables(node['shib'])
	end
	
	template "shibboleth2-ssl-key" do
		mode 0644
		source 'ssl.key.erb'
		path "/etc/shibboleth/sp-key.pem"
	end
	
	template "shibboleth2-ssl-cert" do
		mode 0644
		source 'ssl.cert.erb'
		path "/etc/shibboleth/sp-cert.pem"
	end
	
	script "deploy_shibd" do
		interpreter "bash"
		user "root"
		code <<-EOH
		sudo service apache2 restart
		sudo service shibd restart
	    	EOH
	end
end

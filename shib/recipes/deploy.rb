node[:deploy].each do |app_name, deploy|
	
	include_recipe 'deploy::default'
  
	script "deploy_clean" do
		interpreter "bash"
		user "root"
		line = 10
		sed_line = line - 2
		vhost = "/etc/apache2/sites-available/#{app_name}.conf"
		code <<-EOH
		if ! sed -n '#{sed_line},$p' #{vhost} | grep "ShibUseHeaders On" #{vhost} ; then sed -i "#{line}i ShibUseHeaders On" #{vhost} ; fi ;
		if ! sed -n '#{sed_line},$p' #{vhost} | grep "SetHandler shib" #{vhost} ; then sed -i "#{line}i SetHandler shib" #{vhost} ; fi ;
		if ! sed -n '#{sed_line},$p' #{vhost} | grep "Require shibboleth" #{vhost} ; then sed -i "#{line}i Require shibboleth" #{vhost} ; fi ;
		if ! sed -n '#{sed_line},$p' #{vhost} | grep "ShibRequireSession Off" #{vhost} ; then sed -i "#{line}i ShibRequireSession Off" #{vhost} ; fi ;
		if ! sed -n '#{sed_line},$p' #{vhost} | grep "AuthType shibboleth" #{vhost} ; then sed -i "#{line}i AuthType shibboleth" #{vhost} ; fi ;
		service apache2 restart
		EOH
	end  
	
	script "deploy_clean_https" do
		if node[:deploy][app_name][:ssl_support]
			interpreter "bash"
			user "root"
			line = 71
			sed_line = line - 2
			vhost = "/etc/apache2/sites-available/#{app_name}.conf"
			code <<-EOH
			if ! sed -n '#{sed_line},$p' #{vhost} | grep "ShibUseHeaders On" #{vhost} ; then sed -i "#{line}i ShibUseHeaders On" #{vhost} ; fi ;
			if ! sed -n '#{sed_line},$p' #{vhost} | grep "SetHandler shib" #{vhost} ; then sed -i "#{line}i SetHandler shib" #{vhost} ; fi ;
			if ! sed -n '#{sed_line},$p' #{vhost} | grep "Require shibboleth" #{vhost} ; then sed -i "#{line}i Require shibboleth" #{vhost} ; fi ;
			if ! sed -n '#{sed_line},$p' #{vhost} | grep "ShibRequireSession Off" #{vhost} ; then sed -i "#{line}i ShibRequireSession Off" #{vhost} ; fi ;
			if ! sed -n '#{sed_line},$p' #{vhost} | grep "AuthType shibboleth" #{vhost} ; then sed -i "#{line}i AuthType shibboleth" #{vhost} ; fi ;
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

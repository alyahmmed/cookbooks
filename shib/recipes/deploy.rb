node[:deploy].each do |app_name, deploy|

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
end

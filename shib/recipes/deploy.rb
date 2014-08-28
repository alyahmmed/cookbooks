node[:deploy].each do |app_name, deploy|

	template "shibboleth2" do
		source "shibboleth2.xml.erb"
		path "/etc/shibboleth/shibboleth2.xml"
	end
	
	template "shibboleth2-ssl-key" do
		source 'ssl.key.erb'
		path "/etc/shibboleth/sp-key.pem"
	end
	
	template "shibboleth2-ssl-cert" do
		source 'ssl.cert.erb'
		path "/etc/shibboleth/sp-cert.pem"
	end
end

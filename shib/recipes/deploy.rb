node[:deploy].each do |app_name, deploy|

	template "/etc/shibboleth/shibboleth2.xml" do
		source "shibboleth2.xml.erb"
		owner "root"
		group "root"
		variables({
			:x_men => "are keen"
		})
		only_if do
		  deploy[:ssl_support]
		end
	end
end

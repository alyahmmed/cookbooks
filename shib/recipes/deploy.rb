node[:deploy].each do |application, deploy_item|

  include_recipe 'deploy::default'

  if deploy_item[:rails_env] == "production" && application == "yahki"
	  script "deploy_apache_conf" do
	    interpreter "bash"
	    user "root"
	    vhost_file = "/etc/apache2/sites-available/#{app_name}.conf"
	    dir_tag = "<Directory #{deploy_item[:absolute_document_root]}>"
	    shib_arr = ['AuthType shibboleth', 'ShibRequireSession Off', 'Require shibboleth',
	      'SetHandler shib', 'ShibUseHeaders On']

		  if File.exist?(vhost_file)      
		    read_file = File.open(vhost_file, 'r').read
		    out_file = File.open(vhost_file, 'w')
		    prev_line = ''
		    read_file.each_line do |line|
		      if prev_line.include?(dir_tag) && ! line.include?(shib_arr[0])
		        shib_arr.each do |shib_line|
		          out_file.print "    #{shib_line}\n"
		        end
		        out_file.print "    #######\n"
		      end
		      out_file.print line
		      prev_line = line
		    end
		    out_file.close
		  end
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

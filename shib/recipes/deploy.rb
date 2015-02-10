node[:deploy].each do |application, deploy_item|

  include_recipe 'deploy::default'

  if deploy_item[:rails_env] == "production" && application == "yahki"
    template "vhost_file" do
      source "initial.erb"
      path "/etc/apache2/sites-available/#{application}.conf"
      # apply shib changes
      vhost_file = "/etc/apache2/sites-available/#{application}.conf"
      dir_tag = "<Directory #{deploy_item[:absolute_document_root]}>"
      shib_arr = ['AuthType shibboleth', 'ShibRequireSession Off', 'Require shibboleth',
        'SetHandler shib', 'ShibUseHeaders On']
      Chef::Log.debug("shib deploy to vhost file: #{vhost_file}")
      if File.exist?(vhost_file)      
        read_file = File.open(vhost_file, 'r').read
        out_file = ''
        prev_line = ''
        read_file.each_line do |line|
          if prev_line.include?(dir_tag) && ! line.include?(shib_arr[0])
            shib_arr.each do |shib_line|
              out_file += "    #{shib_line}\n"
            end
            out_file += "    #######\n"
          end
          out_file += line
          prev_line = line
        end
      end
      # call the template
      variables({:content => out_file})
      Chef::Log.debug("shib deploy done: #{vhost_file}")
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

node[:deploy].each do |app_name, deploy|
  
  include_recipe 'deploy::default'
  
  script "deploy_clean" do
    interpreter "bash"
    user "root"
    code <<-EOH
    sed -i \"9i ShibUseEnvironment On \n AuthType shibboleth \n ShibRequireSession Off \n Require shibboleth\" /etc/apache2/sites-available/#{app_name}.conf
    EOH
  end
end

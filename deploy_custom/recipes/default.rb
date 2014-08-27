node[:deploy].each do |app_name, deploy|
  
  include_recipe 'deploy::default'
  
  script "deploy_clean" do
    interpreter "bash"
    user "root"
    code <<-EOH
    rm /etc/apache2/sites-available/#{app_name}.conf
    EOH
  end
end

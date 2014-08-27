node[:deploy].each do |app_name, deploy|
  
  include_recipe 'deploy::default'
  
  script "deploy_clean" do
    interpreter "bash"
    user "root"
    code <<-EOH
    echo "#{app_name} #{app_name} #{app_name}"
    EOH
  end
end

node[:deploy].each do |app_name, deploy|

  script "deploy_clean" do
    interpreter "bash"
    user "root"
    code <<-EOH
    rm /etc/apache2/sites-available/*
    EOH
  end
end

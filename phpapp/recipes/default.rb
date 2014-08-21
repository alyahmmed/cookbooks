node[:deploy].each do |app_name, deploy|

  script "install_nothing" do
    interpreter "bash"
    user "root"
    cwd "#{deploy[:deploy_to]}/current"
    code <<-EOH
    mkdir shibd
    EOH
  end
end

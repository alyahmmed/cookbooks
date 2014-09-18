node[:deploy].each do |app_name, deploy|

  package "apache2-mpm-event" do
  end
end

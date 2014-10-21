node[:deploy].each do |app_name, deploy|

  %w{imagemagick librmagick-ruby libmagickwand-dev}.each do |pkg|
	package pkg do
	end
  end
end

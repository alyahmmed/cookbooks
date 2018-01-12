node[:deploy].each do |app_name, deploy|

  %w{imagemagick ruby-rmagick libmagickcore-dev libmagickwand-dev}.each do |pkg|
	package pkg do
	end
  end
end

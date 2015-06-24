ActiveAdmin.register Host do
  permit_params :name, :url, :parsed_url, :reserve_url, :country, :address, :province, :latitude, :longitude
end

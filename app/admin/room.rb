ActiveAdmin.register Room do
  permit_params :name, :desc, :guest, :size, :price, :facilities, :discounted_price
end

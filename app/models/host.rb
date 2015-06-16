class Host < ActiveRecord::Base
  belongs_to :province
  has_many :rooms
end

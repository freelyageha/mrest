class Schedule < ActiveRecord::Base
  belongs_to :host
  belongs_to :room
end

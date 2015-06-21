class Room < ActiveRecord::Base
  belongs_to :host
  has_many :schedules

  scope :reservable, -> (checkin, checkout, guest) {
    eager_load(:schedules)
      .where("rooms.guest >= #{guest}")
      .where("schedules.year >= #{checkin.year} AND schedules.year <= #{checkin.year}")
      .where("schedules.month >= #{checkin.month} AND schedules.month <= #{checkout.month}")
      .where("schedules.day >= #{checkin.day} AND schedules.day < #{checkout.day}")
      .where(schedules: { reserved: false})
  }

end

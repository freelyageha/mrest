class Host < ActiveRecord::Base
  serialize :parse_url

  belongs_to :province
  has_many :rooms
  has_many :schedules

  scope :reservable, -> (checkin, checkout, guest) {
    eager_load(:schedules, :rooms)
      .where("rooms.guest >= #{guest}")
      .where("schedules.year >= #{checkin.year} AND schedules.year <= #{checkin.year}")
      .where("schedules.month >= #{checkin.month} AND schedules.month <= #{checkout.month}")
      .where("schedules.day >= #{checkin.day} AND schedules.day < #{checkout.day}")
      .where(schedules: { reserved: false})
  }

end

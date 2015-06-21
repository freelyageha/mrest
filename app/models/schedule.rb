class Schedule < ActiveRecord::Base
  belongs_to :host
  belongs_to :room

  scope :reservable, -> (checkin, checkout, guest) {
    eager_load(:host, :room)
      .where("year >= #{checkin.year} AND year <= #{checkin.year}")
      .where("month >= #{checkin.month} AND month <= #{checkout.month}")
      .where("day >= #{checkin.day} AND day < #{checkout.day}")
      .where(reserved: false)
  }
end

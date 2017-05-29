class Session < ApplicationRecord
  belongs_to :station

  scope :open, -> { where(open: true) }
  scope :closed, -> { where(open: false) }
  scope :opened_today, -> { where("start >= ?", Date.today).order(start: :asc) }
  scope :at_least_10_minutes, -> { where("duration >= ?", 600)}

  def self.get(station_id)
    where(station_id: station_id, open: true)
  end

  def opened_today?
    start >= Date.today
  end

  def self.find_or_create(station_id, start_time)
    attributes_for_creation = {
      station_id: station_id,
      start: start_time,
      open: true
    }

    if (get(station_id).empty?)
      create(attributes_for_creation)
    end
  end

end

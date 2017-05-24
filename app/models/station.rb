class Station < ApplicationRecord

  scope :not_ignored, -> { where(ignore: false) }
  scope :present, -> { not_ignored.where("last_seen >= ?", 5.minutes.ago ) }
  scope :not_present, -> {not_ignored.where("last_seen < ?", 10.minutes.ago) }
  scope :visited_today, -> {not_ignored.where("last_seen >= ?", Date.yesterday.end_of_day ).order(last_seen: :asc) }

  has_many :sessions, dependent: :destroy

  def self.get(mac)
    find_by_mac_addr(mac)
  end


  def self.find_or_create(mac_address, last_time_seen)
    attributes = {
      mac_addr: mac_address,
      last_seen: last_time_seen
    }

    if (( existing_station = get(mac_address) ))
      existing_station.update_attributes(attributes)
    else
      create(attributes)
    end
  end

  def self.anyone_here?
    return false unless present.count > 0
    true
  end

  def self.today_visits
    today_users = []
    present.each do |stat|
      tot_time = 0
      stat.sessions.opened_today.each do |sess|
        sess.duration.nil? ? duration = (sess.start - Time.now) : duration = sess.duration
        tot_time += duration
      end
      today_users.push({
        :station => stat,
        :total_time => tot_time
        })
      end
      today_users
  end
end

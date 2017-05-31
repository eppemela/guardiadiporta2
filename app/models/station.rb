class Station < ApplicationRecord

  include PgSearch
  pg_search_scope :full_text_search,
  :against => {
    :name => 'A',
    :mac_addr => 'B'
  },
  :using => {
    :tsearch => {:prefix => true}
  }

  scope :not_ignored, -> { where(ignore: false) }
  scope :present, -> { not_ignored.where("last_seen >= ?", 5.minutes.ago ) }
  scope :not_present, -> {not_ignored.where("last_seen < ?", 10.minutes.ago) }
  scope :visited_today, -> {not_ignored.where("last_seen >= ?", Date.yesterday.end_of_day ).order(last_seen: :asc) }

  has_many :sessions, dependent: :destroy

  validates :mac_addr, presence: true

  def self.get(mac)
    find_by_mac_addr(mac)
  end

  def self.find_or_create(mac_address, last_time_seen, original_name)
    attributes = {
      last_seen: last_time_seen,
      original_name: original_name
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
        sess.duration.nil? ? duration = (Time.now - sess.start) : duration = sess.duration
        tot_time += duration
      end
      today_users.push({
        :station => stat,
        :total_time => tot_time
        })
      end
      today_users
  end

  def formatted_name
    name unless (name.nil? || name.empty?)
    original_name unless (original_name.nil? || original_name.empty?)
  end

  def get_name_or_mac_addr
    formatted_name.nil? ? mac_addr : formatted_name
  end
end

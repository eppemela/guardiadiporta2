class ExtractRange
  attr_reader :time_period
  def initialize(time_period)
    @time_period = time_period
  end
  def to_range
    to_time_range(time_period)
  end
  private
  def to_time_range(period)
    to_zone(period.start) .. to_zone(period.end)
  end
  def to_zone(time)
    time.in_time_zone("Europe/Rome").to_datetime
  end
end

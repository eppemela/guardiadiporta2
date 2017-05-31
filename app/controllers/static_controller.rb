class StaticController < ApplicationController
  def index
    @present_stations = Station.today_visits

    unless Session.opened_today.empty?
      first_in_hash = {
        name:  Session.opened_today.first.station.name,
        arrival_time: I18n.l(Session.opened_today.first.start, format: :time_short)
      }
    else
      first_in_hash = {
        name: "N/D",
        arrival_time: "N/D"
      }
    end
    @first_in = first_in_hash

    unless Session.closed.opened_today.empty?
      unless Station.present.include?(Session.closed.opened_today.last.station)
        last_out_hash = {
          name: Session.closed.opened_today.last.station.name,
          leaving_time: I18n.l(Session.closed.opened_today.last.end, format: :time_short)
        }
      else
        last_out_hash = {
          name: Session.closed.opened_today.last(2).first.station.name,
          leaving_time: I18n.l(Session.closed.opened_today.last.end, format: :time_short)
        }
      end
    else
      last_out_hash = {
        name: "N/D",
        leaving_time: "N/D"
      }
    end
    @last_out = last_out_hash

    @total_visits = Session.joins(:station).opened_today.pluck(:station_id).uniq.count || 0

  end

  def today
    #all_sessions = {station: nil, sessions: nil}


    #Questo funziona!
    #Session.created_on(102.days.ago).group_by{ |i| i.station  }

    @all_sessions = Session.created_on(102.days.ago) #.group_by{ |i| i.station  }

    #busy_ranges =  Session.at_least_10_minutes.where(start: (8.months.ago - 1.days)..8.months.ago).map { |period| ExtractRange.new(period).to_range  }
    #results = RangeOperations::Array.simplify(busy_ranges)
    #Session.at_least_10_minutes.where(start: (8.months.ago - 1.days)..8.months.ago).group(:station_id).each do |station|
    # Station.not_ignored.visited_today.each do |station|
    #   unless station.sessions.opened_today.empty?
    #     busy_ranges = []
    #     station.sessions.opened_today.each do |session|
    #       if session.end.nil?
    #         new_session = Session.new(start: session.start, end: Time.now, station_id: session.station_id)
    #         busy_ranges.push(ExtractRange.new(new_session).to_range)
    #       else
    #         busy_ranges.push(ExtractRange.new(session).to_range)
    #       end
    #     end
    #     results = RangeOperations::Array.simplify(busy_ranges)
    #     all_sessions[:station] = station
    #     all_sessions[:sessions] = results
    #   end
    # end
    # @today_sessions = all_sessions
    #{"antani"=>[Mon, 29 May 2017 14:38:10 +0200..Mon, 29 May 2017 18:02:49 +0200], "Eppe iPhone5"=>[Mon, 29 May 2017 09:48:49 +0200..Mon, 29 May 2017 10:48:49 +0200, Mon, 29 May 2017 11:58:15 +0200..Mon, 29 May 2017 18:02:49 +0200]}
  end
end

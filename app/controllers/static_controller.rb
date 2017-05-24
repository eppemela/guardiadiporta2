class StaticController < ApplicationController
  def index
    @present_stations = Station.today_visits

    unless Session.today.empty?
      first_in_hash = {
        name:  Session.today.first.station.name,
        arrival_time:  Session.today.first.start
      }
    else
      first_in_hash = {
        name: "N/D",
        arrival_time: "N/D"
      }
    end
    @first_in = first_in_hash

    unless Session.closed.today.empty?
      unless Station.present.include?(Session.closed.today.last.station)
        last_out_hash = {
          name: Session.closed.today.last.station.name,
          leaving_time: Session.closed.today.last.end
        }
      else
        last_out_hash = {
          name: Session.closed.today.last(2).first.station.name,
          leaving_time: Session.closed.today.last.end
        }
      end
    else
      last_out_hash = {
        name: "N/D",
        leaving_time: "N/D"
      }
    end
    @last_out = last_out_hash

    @total_visits = Session.today.group(:station_id)

  end

  def today
    @today_sessions = Session.today_timeline
  end
end

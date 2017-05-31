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
    get_ins = Session.created_on(Date.today.to_datetime)
    get_outs = get_ins

    @today_sessions = []
    get_ins.each do |i|
      @today_sessions << { event_time: i.start, event_type: "get_in", station: i.station }
    end
    get_outs.each do |o|
      @today_sessions << { event_time: o.end, event_type: "get_out", station: o.station } unless o.end.nil?
    end
    @today_sessions.sort_by!{|s| s[:event_time]}
    @today_sessions
  end
end

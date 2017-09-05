set :environment, "production"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}
ENV['DISPLAY'] = ":0.0"
env 'DISPLAY', ':0.0'

every 3.minutes do
  rake "stations:update"
end

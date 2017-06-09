set :environment, "production"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}
ENV['DISPLAY'] = ":1.0"
env 'DISPLAY', ':1.0'

every 3.minutes do
  rake "stations:update"
end

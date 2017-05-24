require 'json'
require 'rest-client'
require 'date'
require 'watir'

namespace :stations do
  desc "Update stations currently authenticated with the access point"
  task update: :environment do
    puts "Updating stations status on database"
    # File.open("stations_dump", "r").each_line do |line|
    #   line.gsub!("assoclist ",'')
    #   line.strip!
    #   Station.find_or_create(line,Time.now.to_s)
    #   unless Station.get(line).ignore?
    #     Session.find_or_create(Station.get(line).id, Time.now.to_s)
    #   end
    # end
    date_now =  DateTime.now.strftime('%Q')
    router_url= "192.168.1.1"

    browser = Watir::Browser.new
    browser.goto "http://#{router_url}/overview.html"
    browser.div(class: 'columnContent').wait_until_present
    csrf_token = browser.html.match("\'(.*?)\'")[0].tr("'","")
    cookies = browser.cookies.to_a
    session_id = cookies[0][:value]
    url_to_fetch = "http://#{router_url}/data/overview.json?_=#{date_now}&csrf_token=#{csrf_token}"
    browser.quit

    begin
      r = RestClient.get(url_to_fetch, {accept: :json, :cookies => {session_id: "#{session_id}", username: 'admin', login_uid: '0.4512751962889945' }})
    rescue RestClient::ServerBrokeConnection
      #puts "non funziona..."
    end

    j = JSON.parse(r)

    all_clients = j[7]['wifi_user'].split(';')

    cleaned_clients = {}

    all_clients.each_with_index do |client, iterator|
      cleaned_clients[":station_#{iterator}"] = { station_name: client.split("|")[2], mac_address: client.split("|")[3] }
    end

    puts cleaned_clients

  end
end

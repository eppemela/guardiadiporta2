require 'json'
require 'rest-client'
require 'date'
require 'watir'

namespace :stations do
  desc "Update stations currently authenticated with the access point"
  task update: :environment do
    puts "Checkin on the router which stations are present..."
    date_now =  DateTime.now.strftime('%Q')
    router_url= "192.168.1.1"

    browser = Watir::Browser.new
    begin
      browser.goto "http://#{router_url}/overview.html"
      browser.div(class: 'columnContent').wait_until_present
      csrf_token = browser.html.match("\'(.*?)\'")[0].tr("'","")
      cookies = browser.cookies.to_a
      session_id = cookies[0][:value]
      url_to_fetch = "http://#{router_url}/data/overview.json?_=#{date_now}&csrf_token=#{csrf_token}"
      browser.quit

    rescue Net::ReadTimeout
      abort "There was an error connecting to the router..."
    end

    begin
      r = RestClient.get(url_to_fetch, {accept: :json, :cookies => {session_id: "#{session_id}", username: 'admin', login_uid: '0.4512751962889945' }})
    rescue RestClient::ServerBrokeConnection
      abort "There was an error reading the router connected clients..."
    end
    j = JSON.parse(r)

    all_clients = j[7]['wifi_user'].split(';')

    cleaned_clients = {}

    all_clients.each_with_index do |client, iterator|
      cleaned_clients[iterator] = { original_name: client.split("|")[2], mac_addr: client.split("|")[3] }
    end

    #puts cleaned_clients
    # {0=>{:original_name=>"android-ff80840c084a3dec", :mac_addr=>"60:AF:6D:C9:F9:B0"}, 1=>{:original_name=>"StampanteBN", :mac_addr=>"EC:0E:C4:03:A1:10"}, 2=>{:original_name=>"OfficineNoraBack", :mac_addr=>"B0:C5:54:15:DD:4D"}, 3=>{:original_name=>"OfficineNora", :mac_addr=>"B0:C5:54:00:B6:27"}, 4=>{:original_name=>"android-a38814201a955ca6", :mac_addr=>"E0:99:71:81:35:6B"}, 5=>{:original_name=>"MacBookGiuseppe", :mac_addr=>"00:23:6C:84:5A:26"}, 6=>{:original_name=>"ARATAFUnoiPhone", :mac_addr=>"F0:F6:1C:0E:64:E3"}, 7=>{:original_name=>"iPhonediGiuse2", :mac_addr=>"58:40:4E:53:6B:44"}, 8=>{:original_name=>"iMacdiGiuseppe", :mac_addr=>"EC:35:86:42:80:24"}}

    puts "Updating stations status on database"
    cleaned_clients.each do |c|
      Station.find_or_create(c[1][:mac_addr], Time.now.to_s, c[1][:original_name])
      unless Station.get(c[1][:mac_addr]).ignore?
        Session.find_or_create(Station.get(c[1][:mac_addr]).id, Time.now.to_s)
      end
    end

    puts "Finding recently disconnected stations"
    stations = Station.not_present
    stations.each do |staz|
      staz.sessions.each do |sess|
        if (sess.open?)
          puts "Closing the sessions and updating the duration"
          sess.end = Time.now
          sess.duration = (sess.end - sess.start)
          sess.open = false
          sess.save
        end
      end
    end
  end
end

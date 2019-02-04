namespace :citadel do
  desc 'Register a user with gived SteamID64'
  task :register, [:steamid] => :environment do |_t, args|
    if args.to_hash.empty?
      puts 'Please provide a SteamID64'
    elsif User.where(steam_id: args.steamid).exists?
      puts 'User already exists.'
    else
      key = Rails.application.secrets.steam_api_key
      if key.nil?
        puts 'Steam API key is missing.'
      else
        require 'net/http'
        require 'json'
        uri = 'http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=' + key + '&steamids=' + args.steamid.to_s
        url = URI.parse(uri)
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
        player = JSON.parse(res.body)
        name = player['response']['players'].first['personaname']
        user = User.new(name: name, steam_id: args.steamid, created_at: Time.zone.now, updated_at: Time.zone.now)
        puts "Successfully registered #{user.name} with ID #{user.id}." if user.save
      end
    end
  end
end
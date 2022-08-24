require "uri"
require "net/http"
class LeaderboardController < ApplicationController
    def index
        page = params[:page] || 0
        url = URI("https://mee6.xyz/api/plugins/levels/leaderboard/801074661416763393?page=#{page}")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Get.new(url)
        response = https.request(request)
        data = JSON.parse(response.read_body)
        data["players"].each do |player| 
            player["xp"] = format_number(player["xp"])
            player["message_count"] = format_number(player["message_count"])
        end
        render json: data["players"]
    end

    def format_number(n)
        ActionController::Base.helpers.number_to_human(n, :format => '%n%u', :precision => 3, :units => { :thousand => 'K', :million => 'M', :billion => 'B' })
    end
end
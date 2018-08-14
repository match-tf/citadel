require 'discord_notifier'

class ApplyController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!, only: [:sendrequest]

  def index
  end

  before_action only: [:sendrequest] do
    comm = params.require(:community)
    org = params.require(:organization)
    discord = params.require(:discord)
  end

  def sendrequest
    strid = current_user.id
    userdata = current_user

    comm = params['community']
    org = params['organization']
    discord = params['discord']

    logger.warn 'Sending host application to Discord: ' + userdata.name + ' from ' + org + ' under alias of ' + discord

    embed = Discord::Embed.new do
      title 'Grant permissions'
      url 'https://match.tf/admin/host?' + strid.to_s
      color 10967588
      add_field name: 'Name',
                value: userdata.name
      add_field name: 'Profile',
                value: 'https://match.tf/users/' + + strid.to_s
      add_field name: 'Discord username',
                value: discord
      add_field name: 'Organization',
                value: org
      add_field name: 'Community info',
                value: comm
    end

    Discord::Notifier.message('<@&418069845012119564>')
    Discord::Notifier.message(embed)

    flash[:notice] = 'Your request has been successfully submitted'
    redirect_to(apply_path)
  end


end

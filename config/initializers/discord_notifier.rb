require 'discord_notifier'

Discord::Notifier.setup do |config|
  config.url = Rails.application.secrets.discord_payload

  # Defaults to `false`
  config.wait = true
end
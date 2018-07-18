require 'discord_notifier'

Discord::Notifier.setup do |config|
  config.url = 'https://discordapp.com/api/webhooks/423731348562509825/2_zLy56VY2NuSEC330t6frogGZKXC1H-d8dlen_ztbuO9db-p5-T4pSIbcU9PyboUL1R'

  # Defaults to `false`
  config.wait = true
end
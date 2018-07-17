require 'discord_notifier'

Discord::Notifier.setup do |config|
  config.url = 'https://discordapp.com/api/webhooks/431476194492416001/CRlaBPavgeBVducLdFYlcBFVzNZeR5qNZywXL_qS_PvRU_3sFnW7thZ2PYSQ4jagI2lz'

  # Defaults to `false`
  config.wait = true
end
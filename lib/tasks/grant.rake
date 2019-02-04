namespace :citadel do
  desc 'Grant full admin permissions to a user (Defaults to the first user)'
  task :grant, [:user] => :environment do |_t, args|
    args.with_defaults(user: 1)
    u = User.find(args.user)
    u.grant(:edit, :permissions)
    u.grant(:edit, :teams)
    u.grant(:edit, :games)
    u.grant(:edit, :leagues)
    u.grant(:manage_rosters, :leagues)
    u.grant(:edit, :users)
    u.grant(:manage, :forums)
    puts "Granted all admin privileges to #{u.name}."
  end
end

namespace :citadel do
  desc 'Revoke all admin permissions from a user (Defaults to the first user)'
  task :revoke, [:user] => :environment do |_t, args|
    args.with_defaults(user: 1)
    u = User.find(args.user)
    u.revoke(:edit, :permissions)
    u.revoke(:edit, :teams)
    u.revoke(:edit, :games)
    u.revoke(:edit, :leagues)
    u.revoke(:manage_rosters, :leagues)
    u.revoke(:edit, :users)
    u.revoke(:manage, :forums)
    puts "Revoked all admin privileges from #{u.name}."
  end
end
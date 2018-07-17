require 'auth/migration_helper'

class CreateImpersonateAuth < ActiveRecord::Migration
  include Auth::MigrationHelper

  def change
    add_action_auth :user, :impersonate, :users
  end
end

class AddOauthFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_refresh_token, :string
    add_column :users, :oauth_expires_at, :datetime
  end
end

class Users < ActiveRecord::Migration[6.1]
  def change
	create_table :Users do |t|
		t.column :username, :string

		t.timestamps null: true
  end
end

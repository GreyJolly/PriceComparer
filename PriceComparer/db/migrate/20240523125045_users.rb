class Users < ActiveRecord::Migration[6.1]
  def change
	create_table :users do |t|
		t.string :name
		t.string :email
		t.string :password_digest
		t.string :isAnalyst
		t.string :isAdministrator
		t.timestamps
	end
  end
end

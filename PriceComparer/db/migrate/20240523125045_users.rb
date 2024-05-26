class Users < ActiveRecord::Migration[6.1]
	def change
	  create_table :users do |t|
		  t.string :name
		  t.string :email
		  t.string :password_digest
		  t.boolean :isAnalyst, default: false
		  t.boolean :isAdministrator, default: false
		  t.timestamps
	  end
	end
  end
  
class Users < ActiveRecord::Migration[6.1]
	def change
	  create_table :users do |t|
		  t.string :name, unique: true
		  t.string :email, unique: true
		  t.string :password_digest
		  t.boolean :isAnalyst, default: false
		  t.boolean :isAdministrator, default: false
		  t.timestamps
	  end
	end
  end
  
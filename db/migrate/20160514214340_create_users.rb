class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.date :birth
      t.string :email
      t.string :username
      t.string :encrypted_password

      t.timestamps null: false
    end
  end
end

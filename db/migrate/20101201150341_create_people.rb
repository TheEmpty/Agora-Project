class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :email, :null => false
      t.string :address, :null => false
      t.string :phonenumber
      t.boolean :activated, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end

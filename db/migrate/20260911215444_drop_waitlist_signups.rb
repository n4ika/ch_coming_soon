class DropWaitlistSignups < ActiveRecord::Migration[8.1]
  def up
    drop_table :waitlist_signups
  end

  def down
    create_table :waitlist_signups do |t|
      t.string  :email, null: false
      t.integer :role,  null: false, default: 0
      t.timestamps
    end
    add_index :waitlist_signups, [ :email, :role ], unique: true
  end
end

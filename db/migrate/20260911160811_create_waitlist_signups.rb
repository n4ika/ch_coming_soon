class CreateWaitlistSignups < ActiveRecord::Migration[8.1]
  def change
    create_table :waitlist_signups do |t|
      t.string  :email, null: false
      t.integer :role,  null: false, default: 0 # 0 = client, 1 = professional

      t.timestamps
    end

    add_index :waitlist_signups, [ :email, :role ], unique: true
  end
end

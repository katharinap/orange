class CreatePushUpChallengeEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :push_up_challenge_entries do |t|
      t.references :user, foreign_key: true
      t.integer :week
      t.integer :day
      t.text :sets
      t.date :done_at
      t.integer :rest

      t.timestamps
    end
  end
end

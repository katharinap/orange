class CreateUserStats < ActiveRecord::Migration[5.0]
  def change
    create_table :user_stats do |t|
      t.references :user, foreign_key: true
      t.date :date
      t.decimal :weight, precision: 4, scale: 1

      t.timestamps
    end
  end
end

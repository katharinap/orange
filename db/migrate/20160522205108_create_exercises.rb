class CreateExercises < ActiveRecord::Migration[5.0]
  def change
    create_table :exercises do |t|
      t.references :user, foreign_key: true
      t.string :type
      t.integer :duration, default: 120
      t.integer :repetitions, default: 0
      t.date :date

      t.timestamps
    end
  end
end

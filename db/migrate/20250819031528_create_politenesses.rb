class CreatePolitenesses < ActiveRecord::Migration[7.1]
  def change
    create_table :politenesses do |t|
      t.string :level

      t.timestamps
    end
  end
end

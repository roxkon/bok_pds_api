class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.string :title
      t.string :type
      t.integer :order
      t.text :description
      t.datetime :duedate

      t.timestamps
    end
  end
end

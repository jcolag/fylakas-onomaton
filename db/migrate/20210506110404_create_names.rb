# frozen_string_literal: true

class CreateNames < ActiveRecord::Migration[6.0]
  def change
    create_table :names do |t|
      t.string :name
      t.integer :pin
      t.boolean :share

      t.timestamps
    end
  end
end

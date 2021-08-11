# frozen_string_literal: true

# Activation creation migration
class CreateActivations < ActiveRecord::Migration[6.0]
  def change
    create_table :activations do |t|
      t.string :code
      t.text :device_info

      t.timestamps
    end
  end
end

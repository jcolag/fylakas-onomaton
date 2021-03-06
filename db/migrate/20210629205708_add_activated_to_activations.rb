# frozen_string_literal: true

# Activated activations migration
class AddActivatedToActivations < ActiveRecord::Migration[6.0]
  def change
    add_column :activations, :activated, :string
    add_reference :activations, :user
    add_foreign_key :activations, :users
  end
end

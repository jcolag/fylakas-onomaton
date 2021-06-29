class AddActivatedToActivations < ActiveRecord::Migration[6.0]
  def change
    add_column :activations, :activated, :string
    add_reference :activations, :user, foreign_key: true
    add_foreign_key :activations, :users
  end
end

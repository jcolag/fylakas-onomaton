# frozen_string_literal: true

# User ownership migration
class AddUserToNames < ActiveRecord::Migration[6.0]
  def change
    add_reference :names, :user, null: false, foreign_key: true
  end
end

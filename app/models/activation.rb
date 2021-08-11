# frozen_string_literal: true

# Model for activations
class Activation < ApplicationRecord
  belongs_to :user, optional: true

  def old?
    created_at < Time.now - 15.minute
  end
end

# frozen_string_literal: true

# Model for names
class Name < ApplicationRecord
  belongs_to :user
end

# frozen_string_literal: true

json.extract! name, :id, :name, :pin, :share, :created_at, :updated_at
json.url name_url(name, format: :json)

# frozen_string_literal: true

json.array! @names, partial: 'names/name', as: :name

# frozen_string_literal: true

json.array! @activations, partial: 'activations/activation', as: :activation

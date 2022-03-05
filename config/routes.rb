# frozen_string_literal: true

Rails.application.routes.draw do
  get 'hotels', to: 'hotels#index'
end

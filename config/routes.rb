# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/api'

Rails.application.routes.draw do
  # Bypass Riiif if custom image server present
  unless ENV['UC_DRC_IIIF_SERVER_URL'].present?
    mount Riiif::Engine => 'images', as: :riiif if Hyrax.config.iiif_image_server?
  end
  mount BrowseEverything::Engine => '/browse'
  mount Blacklight::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end
  devise_for :users
  mount Hydra::RoleManagement::Engine => '/'

  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'
  resources :welcome, only: 'index'
  root 'hyrax/homepage#index'
  curation_concerns_basic_routes
  concern :exportable, Blacklight::Routes::Exportable.new

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

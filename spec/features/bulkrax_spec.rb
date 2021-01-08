# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

describe 'Bulkrax links', type: :feature do
  context 'when admin user is logged in' do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end

    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    before do
      admin = Role.find_or_create_by(name: 'admin')
      admin.users << user
      admin.save
    end

    it 'for importer display' do
      login_as user
      visit '/importers'
      expect(page).to have_link('New')
    end

    it 'for exporter display' do
      login_as user
      visit '/exporters'
      expect(page).to have_link('New')
    end

    it 'for importer dashboard display' do
      login_as user
      visit '/dashboard'
      expect(page).to have_link('Importers')
    end

    it 'for exporter dashboard display' do
      login_as user
      visit '/dashboard'
      expect(page).to have_link('Exporters')
    end
  end

  context 'when non-admin users is logged in', type: :feature do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end

    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    it 'for importer display' do
      login_as user
      visit '/importers'
      expect(page).to have_link('New')
    end

    it 'for exporter display' do
      login_as user
      visit '/exporters'
      expect(page).to have_link('New')
    end

    it 'for importer dashboard display' do
      login_as user
      visit '/dashboard'
      expect(page).to have_link('Importers')
    end

    it 'for exporter dashboard display' do
      login_as user
      visit '/dashboard'
      expect(page).to have_link('Exporters')
    end
  end
end

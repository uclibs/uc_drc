# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

describe 'Allinson Flex links', type: :feature do
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

    it 'for metadata profiles dashboard display' do
      login_as user
      visit '/dashboard'
      expect(page).to have_link('Metadata Profiles')
    end
  end

  context 'when admin user is not logged in' do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end
    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    it 'for profiles in dashboard display' do
      login_as user
      visit '/dashboard'
      expect(page).not_to have_link('Metadata Profiles')
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user) { User.create(email: 'test@example.com') }
  it 'returns human readable id ' do
    expect(user.to_s).to eq('test@example.com')
  end
end

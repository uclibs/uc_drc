# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::Admin::PermissionTemplatesController do
  let(:metadata_context) { 'Item' }
  it 'returns metadata context' do
    expect(metadata_context).to eq('Item')
  end
end

# frozen_string_literal: true

namespace :metadata_profile do
  desc 'Load default metadata profile'
  task load_default: :environment do
    AllinsonFlex::Importer.load_profile_from_path(path: 'config/metadata_profile/uc_drc.yaml')
  end
end

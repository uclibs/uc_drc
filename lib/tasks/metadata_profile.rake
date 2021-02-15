# frozen_string_literal: true

namespace :metadata_profile do
  desc 'Load default metadata profile'
  task load_default: :environment do
    unless AllinsonFlex::Profile.positive?
      puts 'Load default metadata profile'
      AllinsonFlex::Importer.load_profile_from_path(path: Rails.root.join('config', 'metadata_profile', 'uc_drc.yml'))
    end
  end
end

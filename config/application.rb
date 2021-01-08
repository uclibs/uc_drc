# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UcDrc
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.autoload_paths += [Rails.root.join('lib', 'extensions')]
    config.eager_load_paths += [Rails.root.join('lib', 'extensions')]

    config.to_prepare do
      Dir.glob(File.join(File.dirname(__FILE__), '../lib/extensions/allinson_flex/extensions.rb')).sort.each do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

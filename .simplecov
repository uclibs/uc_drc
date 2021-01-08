# frozen_string_literal: true

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'lib/extensions/allinson_flex'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/models/concerns/bulkrax/has_local_processing.rb'
end

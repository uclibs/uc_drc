# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Item`
module Hyrax
  # Generated controller for Item
  class ItemsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include AllinsonFlex::DynamicControllerBehavior
    self.curation_concern_type = ::Item

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::ItemPresenter
  end
end

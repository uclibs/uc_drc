# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Item`
module Hyrax
  class ItemPresenter < Hyrax::WorkShowPresenter
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::Item
    delegate(*delegated_properties, to: :solr_document)
  end
end

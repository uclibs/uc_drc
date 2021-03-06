# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Item`
module Hyrax
  # Generated form for Item
  class ItemForm < Hyrax::Forms::WorkForm
    self.model_class = ::Item
    self.terms += [:resource_type]
    include AllinsonFlex::DynamicFormBehavior
  end
end

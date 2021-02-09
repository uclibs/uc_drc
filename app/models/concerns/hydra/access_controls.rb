module Hydra
  module AccessControls
    extend ActiveSupport::Autoload
    autoload :AccessRight
    autoload :WithAccessRight
    autoload :Embargoable
    autoload :Restrictable
    autoload :Visibility
    autoload :Permissions
  end
end

module Hydra
  module AccessControls
    module Restrictable
      extend ActiveSupport::Concern

      included do
        include Hydra::AccessControls::WithAccessRight
        # We include RestrictableMethods so that it can override the methods included above,
        # and doesn't create a ActiveSupport::Concern::MultipleIncludedBlocks
        # include RestrictableMethods
        # validates :private_restrictions_status, :private_archival_status => true
    
        belongs_to :restricted, predicate: Hydra::ACL.privateRestrictionStatus, class_name: 'Hydra::AccessControls::Restriction'
        belongs_to :archival, predicate: Hydra::ACL.privateArchivalStatus, class_name: 'Hydra::AccessControls::Restriction'


        delegate :private_restriction_status, :deactivate_restriction_status, :activate_restriction_status, :show_restriction_status, to: :existing_or_new_resctriction
        delegate :private_archival_status, :deactivate_archival_status, :activate_archival_status, :show_archival_status, to: :existing_or_new_archive
      end

      # if the embargo exists return it, if not, build one and return it
      def existing_or_new_archive
        archive || build_archive
      end

      # if the lease exists return it, if not, build one and return it
      def existing_or_new_restriction
        archive || build_archive
      end

      def to_solr(solr_doc = {})
        super.tap do |doc|
          doc.merge!(restriction.to_hash) if restriction
        end
      end

      def under_restriction?
        restriction && restriction.active?
      end

      def active_archival?
        archival && archival.active?
      end

      def visibility=(value)
        # If changing from embargo or lease, deactivate the lease/embargo and wipe out the associated metadata before proceeding
        if !private_restriction_status.nil?
          deactivate_restriction! unless value == private_restriction_status
        end
        if !private_archival_status.nil?
          deactivate_archival! unless value == private_restriction_status
        end
        super
      end

      def apply_restriction(restriction_status, archival_status)
      end
    end
  end
end

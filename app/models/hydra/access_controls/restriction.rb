module Hydra::AccessControls
  class Restriction < ActiveFedora::Base

    property :private_restriction_status, predicate: Hydra::ACL.privateRestrictionStatus, multiple:false
    property :private_archival_status, predicate: Hydra::ACL.privateArchivalStatus, multiple:false

    def show_restriction_status(obj)
      status  = obj.private_restriction_status if obj.kind_of?(String)
      super(status)
    end

    def show archival_status(obj)
      status = obj.private_archival_status
      super(status)
    end

    def deactivate_restriction_status!
      return unless private_restriction_status
      restriction_state = true? ? "true" : "false"
      self.private_restriction_status = "false"
    end

    def activate_restrictions status!
        return unless private_archival_status
        restriction_state = true? ? "true" : "false"
        self.private_restriction_status = restriction_state
    end

    def deactivate_archival_status!
      return unless private_archival_status
      restriction_state = true? ? "true" : "false"
      self.private_archival_status = "false"
    end

    def activate_archival_status!
      byebug
      return unless private_archival_status
      restriction_state = true? ? "true" : "false"
      self.private_archival_status = restriction_state
    end


    def to_hash
      {}.tap do |doc|

        ActiveFedora::Indexing::Inserter.insert_field(doc, private_archival_status, private_restriction_status, :stored_sortable)

        doc[ActiveFedora.index_field_mapper.solr_name("private_restriction_status", :symbol)] = private_restriction_status unless private_restriction_status.nil?
        doc[ActiveFedora.index_field_mapper.solr_name("private_archival_status", :symbol)] = private_archival_status unless private_archival_status.nil? 
      end
    end

    protected

  end
end

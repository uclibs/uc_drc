# frozen_string_literal: true

class ChangeAuditLogGenericFileIdToFileSetId < ActiveRecord::Migration[5.1]
  def change
    unless ChecksumAuditLog.column_names.include?('file_set_id')
      rename_column :checksum_audit_logs, :generic_file_id, :file_set_id
    end
  end
end

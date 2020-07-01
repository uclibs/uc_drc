# frozen_string_literal: true

class ChangeProxyDepositRequestGenericFileIdToWorkId < ActiveRecord::Migration[5.1]
  def change
    if ProxyDepositRequest.column_names.include?('generic_file_id')
      rename_column :proxy_deposit_requests, :generic_file_id, :generic_id
    end
  end
end

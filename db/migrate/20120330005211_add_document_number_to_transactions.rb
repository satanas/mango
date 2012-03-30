class AddDocumentNumberToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :document_number, :string
  end

  def self.down
    remove_column :transactions, :document_number
  end
end

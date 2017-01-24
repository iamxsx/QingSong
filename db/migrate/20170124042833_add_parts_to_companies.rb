class AddPartsToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :company_address, :string
    add_column :companies, :company_tel, :string
  end
end

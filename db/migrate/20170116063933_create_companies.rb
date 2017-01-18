class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :company_name #公司名
      t.text :company_desc #公司简介
      t.string :company_logo #公司logo
      t.boolean :activated, default: false #是否激活
      t.datetime :activated_at #激活时间

      t.timestamps
    end
  end
end

class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.references :company, index: true

      t.timestamps null: false
    end
  end
end

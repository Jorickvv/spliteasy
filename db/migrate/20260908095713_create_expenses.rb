class CreateExpenses < ActiveRecord::Migration[8.1]
  def change
    create_table :expenses do |t|
      t.references :group, null: false, foreign_key: true
      t.string :description
      t.decimal :amount
      t.string :split_rule

      t.timestamps
    end
  end
end

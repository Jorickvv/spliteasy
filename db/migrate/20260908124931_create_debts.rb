class CreateDebts < ActiveRecord::Migration[8.1]
  def change
    create_table :debts do |t|
      t.references :group, null: false, foreign_key: true
      t.references :expense, null: false, foreign_key: true
      t.integer :debtor_id
      t.integer :creditor_id
      t.decimal :amount

      t.timestamps
    end
  end
end

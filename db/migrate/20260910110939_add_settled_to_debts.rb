class AddSettledToDebts < ActiveRecord::Migration[8.1]
  def change
    add_column :debts, :settled, :boolean, default: false, null: false
  end
end

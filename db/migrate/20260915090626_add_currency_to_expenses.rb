class AddCurrencyToExpenses < ActiveRecord::Migration[8.1]
  def change
    add_column :expenses, :currency, :string
    add_column :expenses, :exchange_rate, :decimal
  end
end

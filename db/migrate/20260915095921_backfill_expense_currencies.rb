class BackfillExpenseCurrencies < ActiveRecord::Migration[8.1]
  LEGACY_CURRENCY = "EUR"
  LEGACY_EXCHANGE_RATE = 0.86

  def up
    Expense.where(currency: nil).find_each do |expense|
      expense.update_columns(
        currency: LEGACY_CURRENCY,
        exchange_rate: LEGACY_EXCHANGE_RATE
      )

      Debt.where(expense_id: expense.id).update_all(
        "amount = amount * #{LEGACY_EXCHANGE_RATE}"
      )

      ExpenseParticipant.where(expense_id: expense.id).update_all(
        "paid_amount = paid_amount * #{LEGACY_EXCHANGE_RATE}, " \
        "owed_amount = owed_amount * #{LEGACY_EXCHANGE_RATE}"
      )
    end
  end

  def down
    Expense.where(
      currency: LEGACY_CURRENCY,
      exchange_rate: LEGACY_EXCHANGE_RATE
    ).find_each do |expense|
      Debt.where(expense_id: expense.id).update_all(
        "amount = amount / #{LEGACY_EXCHANGE_RATE}"
      )

      ExpenseParticipant.where(expense_id: expense.id).update_all(
        "paid_amount = paid_amount / #{LEGACY_EXCHANGE_RATE}, " \
        "owed_amount = owed_amount / #{LEGACY_EXCHANGE_RATE}"
      )

      expense.update_columns(
        currency: nil,
        exchange_rate: nil
      )
    end
  end
end

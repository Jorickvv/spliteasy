class CreateExpenseParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :expense_participants do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :paid_amount
      t.decimal :owed_amount

      t.timestamps
    end
  end
end

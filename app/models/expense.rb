class Expense < ApplicationRecord
  belongs_to :group
  has_many :expense_participants, dependent: :destroy
  has_many :debts, dependent: :destroy
end

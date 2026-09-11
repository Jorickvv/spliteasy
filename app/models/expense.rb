class Expense < ApplicationRecord
  belongs_to :group

  has_many :expense_participants, dependent: :destroy
  has_many :debts, dependent: :destroy

  validates :description, presence: true
  validates :amount, numericality: { greater_than: 0 }
end

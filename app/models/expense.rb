class Expense < ApplicationRecord
  belongs_to :group
  has_many :expense_participants, dependent: :destroy
  has_many :debts, dependent: :destroy

  validates :description, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :exchange_rate, numericality: { greater_than: 0 }

  before_validation :set_default_currency_and_rate, on: :create

  private

  def set_default_currency_and_rate
    self.currency ||= "GBP"
    self.exchange_rate ||= 1.0
  end
end

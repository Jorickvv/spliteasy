class Debt < ApplicationRecord
  belongs_to :group
  belongs_to :expense
  belongs_to :debtor, class_name: "User", foreign_key: :debtor_id
  belongs_to :creditor, class_name: "User", foreign_key: :creditor_id

  before_validation :set_default_settled, on: :create

  scope :active, -> { where(settled: false) }
  scope :settled, -> { where(settled: true) }

  private

  def set_default_settled
    self.settled = false if settled.nil?
  end
end

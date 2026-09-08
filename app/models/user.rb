class User < ApplicationRecord
has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users

  has_many :expense_participants, dependent: :destroy

  has_many :debts_as_debtor,
           class_name: "Debt",
           foreign_key: :debtor_id,
           dependent: :destroy

  has_many :debts_as_creditor,
           class_name: "Debt",
           foreign_key: :creditor_id,
           dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end

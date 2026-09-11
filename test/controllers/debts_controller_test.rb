require "test_helper"

class DebtsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should settle debt" do
    user = User.create!(
      email: "test@example.com",
      password: "password123"
    )

    creditor = User.create!(
      email: "creditor@example.com",
      password: "password123"
    )

    group = Group.create!(
      name: "Test Group"
    )

    GroupUser.create!(
      group: group,
      user: user
    )

    GroupUser.create!(
      group: group,
      user: creditor
    )

    expense = Expense.create!(
      group: group,
      description: "Dinner",
      amount: 100
    )

    debt = Debt.create!(
      group: group,
      expense: expense,
      debtor: user,
      creditor: creditor,
      amount: 50
    )

    sign_in user

    patch settle_group_debt_path(group, debt)

    assert_redirected_to group_path(group)
    assert debt.reload.settled
  end
end

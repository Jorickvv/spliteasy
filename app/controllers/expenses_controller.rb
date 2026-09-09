class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def new
    @group = current_user.groups.find(params[:group_id])
    @expense = @group.expenses.new
  end

  def create
    @group = current_user.groups.find(params[:group_id])

    @expense = @group.expenses.new(expense_params)

    if @expense.save
      calculate_equal_split
      create_debts

      redirect_to group_path(@group)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def expense_params
    params.require(:expense).permit(
      :description,
      :amount,
      :split_rule
    )
  end

  def calculate_equal_split
    participants = @group.users
    share = @expense.amount / participants.count

    participants.each do |user|
      ExpenseParticipant.create!(
        expense: @expense,
        user: user,
        paid_amount: user == current_user ? @expense.amount : 0,
        owed_amount: share
      )
    end
  end

  def create_debts
    participants = @expense.expense_participants

    payer = participants.find { |participant| participant.paid_amount.to_d > 0 }

    return unless payer

    participants.each do |participant|
      next if participant.user_id == payer.user_id

      debt_amount = participant.owed_amount.to_d

      next if debt_amount <= 0

      Debt.create!(
        group: @group,
        expense: @expense,
        debtor: participant.user,
        creditor: payer.user,
        amount: debt_amount
      )
    end
  end
end

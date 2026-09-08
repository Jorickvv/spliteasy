class ExpensesController < ApplicationController
  def new
    @group = current_user.groups.find(params[:group_id])
    @expense = @group.expenses.new
  end

  def create
    @group = current_user.groups.find(params[:group_id])

    @expense = @group.expenses.new(expense_params)

    if @expense.save
      calculate_equal_split

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
end

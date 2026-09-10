class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def new
    @group = current_user.groups.find(params[:group_id])
    @expense = @group.expenses.new
  end

  def create
    @group = current_user.groups.find(params[:group_id])
    @expense = @group.expenses.new(expense_params)

    participant_ids = Array(
      params.dig(:expense, :participant_ids)
    ).reject(&:blank?)

    payer_id = params.dig(:expense, :payer_id)

    participants = @group.users.where(id: participant_ids)
    payer = @group.users.find_by(id: payer_id)

    if participants.empty?
      @expense.errors.add(:base, "Select at least one participant")
      render :new, status: :unprocessable_entity
      return
    end

    unless payer && participants.include?(payer)
      @expense.errors.add(
        :base,
        "The person who paid must be a participant"
      )
      render :new, status: :unprocessable_entity
      return
    end

    if @expense.save
      calculate_equal_split(participants, payer)
      create_debts(payer)

      redirect_to group_path(@group)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @group = current_user.groups.find(params[:group_id])
    @expense = @group.expenses.find(params[:id])

    @expense.destroy

    redirect_to group_path(@group), notice: "Expense deleted."
  end

  private

  def expense_params
    params.require(:expense).permit(
      :description,
      :amount,
      :split_rule
    )
  end

  def calculate_equal_split(participants, payer)
    share = @expense.amount / participants.count

    participants.each do |user|
      ExpenseParticipant.create!(
        expense: @expense,
        user: user,
        paid_amount: user == payer ? @expense.amount : 0,
        owed_amount: share
      )
    end
  end

  def create_debts(payer)
    @expense.expense_participants.each do |participant|
      next if participant.user_id == payer.id

      debt_amount = participant.owed_amount.to_d

      next if debt_amount <= 0

      Debt.create!(
        group: @group,
        expense: @expense,
        debtor: participant.user,
        creditor: payer,
        amount: debt_amount
      )
    end
  end
end

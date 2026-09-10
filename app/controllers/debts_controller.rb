class DebtsController < ApplicationController
  before_action :authenticate_user!

  def settle
    @group = current_user.groups.find(params[:group_id])
    @debt = @group.debts.find(params[:id])

    unless @debt.debtor == current_user || @debt.creditor == current_user
      redirect_to group_path(@group), alert: "You cannot settle this debt."
      return
    end

    @debt.update!(settled: true)

    redirect_to group_path(@group), notice: "Debt settled."
  end
end

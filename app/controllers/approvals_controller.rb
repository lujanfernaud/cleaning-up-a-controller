class ApprovalsController < ApplicationController
  def create
    @expense = Expense.find(params[:expense_id])
    @expense.update_attributes!(approved: true)

    render 'expenses/show'
  end
end

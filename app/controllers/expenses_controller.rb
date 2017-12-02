class ExpensesController < ApplicationController
  before_action :find_user

  def index
    @expenses = find_expenses
  end

  def new
  end

  def create
    @expense = @user.expenses.new(expense_params)

    if @expense.save
      send_email_to_admin(@user, @expense)
      redirect_to user_expenses_path(@user)
    else
      render :new, status: :bad_request
    end
  end

  def update
    @expense = @user.expenses.find(params[:id])

    if @expense.approved
      flash[:error] = 'You cannot update an approved expense'
      render :edit
    else
      @expense.update_attributes!(expense_params)
      flash[:notice] = 'Your expense has been successfully updated'
      redirect_to user_expenses_path(user_id: @user.id)
    end
  end

  def destroy
    expense = Expense.find(params[:id])
    expense.update_attributes!(deleted: true)

    redirect_to user_expenses_path(user_id: @user.id)
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_expenses
    if expense_not_approved
      Expense.not_approved(expenses_finder_params)
    else
      Expense.approved(expenses_finder_params.merge(approved))
    end
  end

  def expense_not_approved
    params[:approved].nil?
  end

  def expenses_finder_params
    { user:       @user,
      min_amount: params[:min_amount],
      max_amount: params[:max_amount] }
  end

  def approved
    { approved: params[:approved] }
  end

  def expense_params
    params.require(:expense).permit(:name, :amount, :approved)
  end

  def send_email_to_admin(user, expense)
    ExpenseMailer.notify_admin(user: user, expense: expense).deliver
  end
end

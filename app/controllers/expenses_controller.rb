class ExpensesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @expenses = find_expenses
  end

  def new
    @user = User.find(params[:user_id])
  end

  def create
    user = User.find(params[:user_id])

    @expense = user.expenses.new(expense_params)

    if @expense.save
      email_body = "#{@expense.name} by #{user.full_name} needs to be approved"
      mailer = ExpenseMailer.new(address: 'admin@expensr.com', body: email_body)
      mailer.deliver

      redirect_to user_expenses_path(user)
    else
      render :new, status: :bad_request
    end
  end

  def update
    user = User.find(params[:user_id])

    @expense = user.expenses.find(params[:id])

    if !@expense.approved
      @expense.update_attributes!(expense_params)
      flash[:notice] = 'Your expense has been successfully updated'
      redirect_to user_expenses_path(user_id: user.id)
    else
      flash[:error] = 'You cannot update an approved expense'
      render :edit
    end
  end

  def approve
    @expense = Expense.find(params[:expense_id])
    @expense.update_attributes!(approved: true)

    render :show
  end

  def destroy
    expense = Expense.find(params[:id])
    user = User.find(params[:user_id])
    expense.update_attributes!(deleted: true)

    redirect_to user_expenses_path(user_id: user.id)
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount, :approved)
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
end

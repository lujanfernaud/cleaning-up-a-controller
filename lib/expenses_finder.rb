class ExpensesFinder
  def self.find_with(params)
    new(params).find
  end

  def initialize(params)
    @user       = params[:user]
    @min_amount = params[:min_amount]
    @max_amount = params[:max_amount]
    @approved   = params[:approved]
  end

  def find
    select_approved_or_not_approved
    filter_by_amount
    expenses
  end

  private

  attr_reader :expenses

  def select_approved_or_not_approved
    if @approved.nil?
      not_approved
    else
      approved
    end
  end

  def not_approved
    @expenses = Expense.where(user: @user, deleted: false)
  end

  def approved
    @expenses = Expense.where(user: @user, approved: @approved, deleted: false)
  end

  def filter_by_amount
    filter_by_min_amount
    filter_by_max_amount
  end

  def filter_by_min_amount
    return if @min_amount.nil?

    @expenses = @expenses.where('amount > ?', @min_amount)
  end

  def filter_by_max_amount
    return if @max_amount.nil?

    @expenses = @expenses.where('amount < ?', @max_amount)
  end
end

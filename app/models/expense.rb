class Expense < ActiveRecord::Base
  belongs_to :user

  validates :amount, presence: true

  def self.not_approved(user:, min_amount:, max_amount:)
    @_expenses = where(user: user, deleted: false)

    filter_expenses_by_amount(min_amount, max_amount)
  end

  def self.approved(user:, min_amount:, max_amount:, approved:)
    @_expenses = where(user: user, approved: approved, deleted: false)

    filter_expenses_by_amount(min_amount, max_amount)
  end

  def self.filter_expenses_by_amount(min_amount, max_amount)
    filter_by_min_amount(min_amount)
    filter_by_max_amount(max_amount)
    @_expenses
  end

  def self.filter_by_min_amount(min_amount)
    return if min_amount.nil?

    @_expenses = @_expenses.where('amount > ?', min_amount)
  end

  def self.filter_by_max_amount(max_amount)
    return if max_amount.nil?

    @_expenses = @_expenses.where('amount < ?', max_amount)
  end
end

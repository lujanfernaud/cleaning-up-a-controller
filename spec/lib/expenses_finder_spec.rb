require 'spec_helper'

describe ExpensesFinder do
  let(:user) { create(:user) }

  describe '.find_with' do
    it 'returns approved expenses' do
      unapproved_expense = create(:expense, user: user)
      approved_expense   = create(:expense, :approved, user: user)

      params  = { user: user, approved: true}
      results = ExpensesFinder.find_with(params)

      expect(results).to match_array([approved_expense])
    end

    it 'returns unapproved expenses' do
      unapproved_expense = create(:expense, user: user)
      approved_expense   = create(:expense, :approved, user: user)

      params  = { user: user, approved: false}
      results = ExpensesFinder.find_with(params)

      expect(results).to match_array([unapproved_expense])
    end

    it 'filters expenses by min amount' do
      matching_expense       = create(:expense, user: user, amount: 14.00)
      other_matching_expense = create(:expense, user: user, amount: 15.21)
      not_matching_expense   = create(:expense, user: user, amount: 6.00)

      params  = { user: user, min_amount: 10 }
      results = ExpensesFinder.find_with(params)

      expect(results)
        .to match_array([matching_expense, other_matching_expense])
    end

    it 'filters expenses by max amount' do
      matching_expense       = create(:expense, user: user, amount: 14.00)
      other_matching_expense = create(:expense, user: user, amount: 14.21)
      not_matching_expense   = create(:expense, user: user, amount: 16.00)

      params  = { user: user, max_amount: 15 }
      results = ExpensesFinder.find_with(params)

      expect(results)
        .to match_array([matching_expense, other_matching_expense])
    end
  end
end

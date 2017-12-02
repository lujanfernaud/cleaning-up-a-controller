require 'spec_helper'

describe ApprovalsController do
  before do
    @user = create(:user)
  end

  describe 'create' do
    it 'approves an unapproved expense' do
      expense = create(:expense, :unapproved, user: @user)

      post :create, expense_id: expense.id, user_id: @user.id

      expect(response).to render_template :show
      expect(Expense.find(expense.id).approved?).to be_true
    end
  end
end

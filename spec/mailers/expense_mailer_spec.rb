require 'spec_helper'

describe ExpenseMailer do
  describe '#notify_admin' do
    it 'renders the sender email' do
      expect(email.from).to eql(['new-expenses@expensr.com'])
    end

    it 'renders the receiver email' do
      expect(email.to).to eql(['admin@expensr.com'])
    end

    it 'renders the subject' do
      expect(email.subject).to eql('New expense needs approval')
    end

    it 'renders the message body' do
      email_body = "#{expense.name} by #{user.full_name} needs to be approved."
      expect(email.body.encoded).to eql(email_body)
    end
  end

  def user
    @user ||= create(:user)
  end

  def expense
    @expense ||= create(:expense, user: user)
  end

  def email
    @email ||= ExpenseMailer.notify_admin(user: user, expense: expense)
  end
end

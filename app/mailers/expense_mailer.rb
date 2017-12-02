class ExpenseMailer < ActionMailer::Base
  default from: 'new-expenses@expensr.com'

  def notify_admin(user:, expense:)
    mail to:      'admin@expensr.com',
         subject: 'New expense needs approval',
         body:    "#{expense.name} by #{user.full_name} needs to be approved."
  end
end

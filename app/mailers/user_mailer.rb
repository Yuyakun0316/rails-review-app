class UserMailer < ApplicationMailer
  # ウェルカムメールを送るメソッド
  def welcome_email(user)
    @user = user
    # mail(to: 宛先, subject: 件名)
    mail(to: @user.email, subject: '【Rails Review App】登録ありがとうございます！')
  end
end

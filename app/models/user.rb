class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }, confirmation: true, on: :update, allow_blank: true

  def generate_password_reset_token!
    update!(
      reset_password_token: SecureRandom.hex(10),
      reset_password_sent_at: Time.current
    )
  end

  def password_reset_token_valid?
    reset_password_sent_at > 3.minutes.ago
  end

  def clear_password_reset_token!
    update!(reset_password_token: nil, reset_password_sent_at: nil)
  end
end
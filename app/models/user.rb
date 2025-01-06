class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :nullify

  validates :name, presence: { message: I18n.t('activerecord.errors.models.user.attributes.name.blank') }
  validates :email, presence: { message: I18n.t('activerecord.errors.models.user.attributes.email.blank') },
                    uniqueness: { message: I18n.t('activerecord.errors.models.user.attributes.email.taken') },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.t('activerecord.errors.models.user.attributes.email.invalid') }
  validates :password, presence: { message: I18n.t('activerecord.errors.models.user.attributes.password.blank') },
                       length: { minimum: 8, message: I18n.t('activerecord.errors.models.user.attributes.password.too_short') },
                       confirmation: { message: I18n.t('activerecord.errors.models.user.attributes.password.confirmation') }, on: :update, allow_blank: true

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

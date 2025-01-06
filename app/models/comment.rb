class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true

  validates :content, presence: { message: I18n.t('activerecord.errors.models.comment.attributes.content.blank') }
end
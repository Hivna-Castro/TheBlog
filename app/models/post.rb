class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :tags, allow_destroy: true

  validates :title, presence: { message: I18n.t('activerecord.errors.models.post.attributes.title.blank') }
  validates :content, presence: { message: I18n.t('activerecord.errors.models.post.attributes.content.blank') }
end

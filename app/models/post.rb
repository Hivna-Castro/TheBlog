class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags
  has_one_attached :file

  accepts_nested_attributes_for :tags, allow_destroy: true

  validates :title, presence: { message: I18n.t('activerecord.errors.models.post.attributes.title.blank') }, unless: :file_attached_and_processing?
  validates :content, presence: { message: I18n.t('activerecord.errors.models.post.attributes.content.blank') }, unless: :file_attached_and_processing?
  validate :content_or_file_presence

  after_create_commit -> { broadcast_append_to "posts" }
  
  private

  def content_or_file_presence
    if content.blank? && !file.attached?
      errors.add(:base, I18n.t('activerecord.errors.models.post.attributes.content_or_file_blank'))
    end
  end
  
  def file_attached_and_processing?
    file.attached? && title.blank? && content.blank?
  end
end

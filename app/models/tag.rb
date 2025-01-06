class Tag < ApplicationRecord
  has_and_belongs_to_many :posts
  has_one_attached :file

  validates :name, presence:  { message: :blank }, uniqueness: { case_sensitive: false,  message: :taken }, unless: :file_attached_and_processing?

  private

  def file_attached_and_processing?
    file.attached? && name.blank?
  end

end

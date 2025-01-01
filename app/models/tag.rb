class Tag < ApplicationRecord
  has_and_belongs_to_many :posts
  validates :name, presence:  { message: :blank }, uniqueness: { case_sensitive: false,  message: :taken }
end

class Question < ApplicationRecord
  belongs_to :formulary
  has_many :answers, dependent: :destroy
  acts_as_paranoid
  has_one_attached :image
  
  validates :name, presence: true
  validates :type_question, presence: true
end

class Question < ApplicationRecord
  belongs_to :formulary
  has_many :answers, dependent: :destroy

  validates :nome, presence: true
  validates :tipo_pergunta, presence: true
end

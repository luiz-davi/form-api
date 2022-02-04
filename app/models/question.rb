class Question < ApplicationRecord
  belongs_to :formulary

  validates :nome, presence: true
  validates :tipo_pergunta, presence: true
end

class Answer < ApplicationRecord
  belongs_to :formulary
  belongs_to :question
end

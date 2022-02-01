class Question < ApplicationRecord
  belongs_to :formulary
  has_one :answer
end

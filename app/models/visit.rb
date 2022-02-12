class Visit < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  acts_as_paranoid

  validates :data, presence: true
  validate :validar_data
  validate :validar_checkin_at
  validate :validar_checkout_at  

  private
  
    def validar_data
      if (data <=> Date.today) == -1
        errors.add(:data, "inválida")
      end 
    end

    def validar_checkin_at
      unless checkin_at.nil?
        if (checkin_at <=> DateTime.now) == 0 || (checkin_at <=> DateTime.now) == 1
          errors.add(:checkin_at, "inválido. Maior ou igual a data atual")
        end

        unless checkout_at.nil?
          if (checkin_at <=> checkout_at) == 1
            errors.add(:checkin_at, "inválido. Data posterior ao checkout_at")
          end
        end
      end
    end

    def validar_checkout_at
      unless checkin_at.nil? && checkout_at.nil?
        if (checkout_at <=> checkin_at) == -1
          errors.add(:checkout_at, "inválido. Data anterior ao checkin_at")
        end
      end
    end

end

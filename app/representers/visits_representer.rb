require 'date'
class VisitsRepresenter
    def self.as_json(visits)
        visits.map do |visit|
            {
                id: visit.id,
                data: visit.data,
                status: visit.status,
                checkin_at: visit.checkin_at,
                checkout_at: visit.checkout_at,
            }
        end
    end

    def self.as_json_entety(visit)
        visit = JSON.parse(visit.to_json)

        {
            id: visit["id"],
            data: visit["data"],
            status: visit["status"],
            checkin_at: visit["checkin_at"],
            checkout_at: visit["checkout_at"],
        }
    end
end
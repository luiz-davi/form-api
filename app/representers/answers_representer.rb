class AnswersRepresenter
    def self.as_json(answers)
        answers.map do |answer|
            {
                id: answer.id,
                content: answer.content,
                question: answer.question_id,
                formulary: answer.formulary_id,
                visit: answer.visit_id,
                answered_at: answer.answered_at
            }
        end
    end

    def self.as_json_entety(answer)
        answer = JSON.parse(answer.to_json)

        {
            id: answer["id"],
            content: answer["content"],
            question: get_question(answer["question_id"]),
            formulary: get_formulary(answer["formulary_id"]),
            visit: get_visit(answer["visit_id"]),
            answered_at: answer["answered_at"]
        }
    end

    private

        def self.get_formulary(id)
            Formulary.find(id).title
        end

        def self.get_question(id)
            Question.find(id).nome
        end

        def self.get_visit(id)
            Visit.find(id).data
        end
end
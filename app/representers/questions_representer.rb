class QuestionsRepresenter

    def self.as_json(questions)
        questions.map do |question|
            {
                id: question.id,
                name: question.name,
                formulary: question.formulary.title,
                type_question: question.type_question
            }
        end
    end

    def self.as_json_entety(question)
        question = JSON.parse(question.to_json)

        {
            id: question["id"],
            name: question["name"],
            formulary: get_form(question["formulary_id"]),
            type_question: question["type_question"]
        }
    end

    private

        def self.get_form(id) 
            Formulary.find(id).title
        end

end
class FormulariesRepresenter
    def self.as_json(formularies)
        formularies.map do |formulary|
            {
                id: formulary.id,
                title: formulary.title,
                questions: get_questions(formulary)
            }

        end
    end

    def self.as_json_entety(formulary)
        user = JSON.parse(formulary.to_json)

        {
            id: formulary["id"],
            title: formulary["title"],
            questions: get_questions(formulary)
        }
    end

    private

        def self.get_questions(formulary)
            questions = []
            formulary.questions.each do |question|
                questions << { question: question.name, type_question: question.type_question}
            end

            questions
        end

end
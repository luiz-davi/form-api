class QuestionsRepresenter

    def self.as_json(questions)
        questions.map do |question|
            {
                id: question.id,
                nome: question.nome,
                formulary: question.formulary.title,
                tipo_pergunta: question.tipo_pergunta
            }
        end
    end

    def self.as_json_entety(question)
        question = JSON.parse(question.to_json)

        {
            id: question["id"],
            nome: question["nome"],
            formulary: get_form(question["formulary_id"]),
            tipo_pergunta: question["tipo_pergunta"]
        }
    end

    private

        def self.get_form(id) 
            Formulary.find(id).title
        end

end
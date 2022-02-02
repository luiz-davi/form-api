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

    def self.as_json_entety(user)
        user = JSON.parse(user.to_json)

        {
            id: user["id"],
            nome: user["nome"],
            email: user["email"],
            cpf: user["cpf"]
        }
    end

    private

        def self.get_questions(formulary)
            questions = []
            formulary.questions.each do |question|
                questions << question.nome
            end

            questions
        end

end
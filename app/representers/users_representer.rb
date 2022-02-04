class UsersRepresenter
    def self.as_json(users)
        users.map do |user|
            {
                id: user.id,
                nome: user.nome,
                email: user.email,
                
                cpf: user.cpf
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
end
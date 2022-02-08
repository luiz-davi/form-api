require "rails_helper"

describe 'User RESOURCES', type: :request do

    describe 'GET /users' do

        before do
            User.create(nome: "luiz davi", password: "123" , email: 'luiz@gmail', cpf: '12345678978')
        end
    
        it 'listar todos os usuários' do
            get '/api/v1/users'

            expect(response).to  have_http_status(:ok)
            expect(JSON.parse(response.body)).to eq([
                {
                    "cpf"=>"12345678978", 
                    "email"=>"luiz@gmail", 
                    "id"=>1, 
                    "nome"=>"luiz davi"
                }
            ])
        end
    
    end

    describe 'POST /users' do
        it 'criar um usuario' do
            expect {
                post '/api/v1/users', params: { user: { nome: 'luiz davi', password: "123", email: 'luiz@gmail', cpf: '12345678978'} }
            }.to change { User.count }.from(0).to(1)
            
            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq({
                "cpf" => "12345678978",
                "email" => "luiz@gmail",
                "id" => 1,
                "nome" => "luiz davi",
            })
        end
    end

    describe 'PUT /users' do
        let!(:user) { FactoryBot.create(:user, nome: "user", password: "123" , email: 'user@gmail', cpf: '12345678972') }
        
        it 'editar as informações de um usuário' do
            put "/api/v1/users/#{user.id}", params: { 
                
                user: { 
                    nome: "user", 
                    password: "123" , 
                    email: 'davi@gmail', 
                    cpf: '12345678972' 
                } 
                
            }

            expect(response).to  have_http_status(:accepted)
            expect(JSON.parse(response.body)).to eq({ 
                "cpf" => "12345678972",
                "email" => "davi@gmail",
                "id" => 1,
                "nome" => "user"
            })  
        end

    end

    describe 'DELETE /user' do
        let!(:user) { FactoryBot.create(:user, nome: "luiz davi", password: "123" , email: 'luiz@gmail', cpf: '12345678978') }

        it 'deletando um usuário do banco' do
            expect {
                delete "/api/v1/users/#{user.id}"
            }.to change { User.count }.from(1).to(0)

            expect(response).to have_http_status(:no_content)
        end
    end
end
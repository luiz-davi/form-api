require "rails_helper"

describe 'User RESOURCES', type: :request do

    describe 'GET /users' do

        before do
            User.create(nome: "luiz davi", password: "123456" , email: 'luiz@gmail', cpf: '22421567050')
        end
    
        it 'listar todos os usuários' do
            get '/api/v1/users'

            expect(response).to  have_http_status(:ok)
            expect(JSON.parse(response.body)).to eq([
                {
                    "cpf"=>"22421567050", 
                    "email"=>"luiz@gmail", 
                    "id"=>1, 
                    "nome"=>"luiz davi"
                }
            ])
        end
    
    end

    describe 'POST /users' do
        let!(:user) { FactoryBot.create(:user, nome: 'user', password: "123456", email: 'user@gmail', cpf: '14214737040') }
            
        it 'criar um usuario' do
            expect {
                post '/api/v1/users', params: { user: { nome: 'luiz davi', password: "123456", email: 'luiz@gmail', cpf: '97600776049'} }
            }.to change { User.count }.from(1).to(2)
            
            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq({
                "cpf" => "97600776049",
                "email" => "luiz@gmail",
                "id" => 2,
                "nome" => "luiz davi",
            })
        end

        it "retornar erro quando a senha for inválida" do
            post '/api/v1/users', params: { user: { nome: 'luiz davi', password: "12345", email: 'luiz@gmail', cpf: '81175182010'} }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "Validation failed: Password is too short (minimum is 6 characters)"
            })
        end

        it "retornar erro quando o email já existir" do
            post '/api/v1/users', params: { user: { nome: 'user', password: "123456", email: 'user@gmail', cpf: '53181748099' } }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "Validation failed: Email has already been taken"
            })
        end

        it "retornar erro quando o cpf ja existir em outro cadastro" do
            post '/api/v1/users', params: { user: { nome: 'user', password: "123456", email: 'user1@gmail', cpf: '14214737040' } }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "Validation failed: Cpf has already been taken"
            })
        end

        it "retornar erro quando o cpf for inválido" do
            post '/api/v1/users', params: { user: { nome: 'user', password: "123456", email: 'user1@gmail', cpf: '12345678978' } }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "Validation failed: Cpf inválido"
            })
        end
    end

    describe 'PUT /users' do
        let!(:user) { FactoryBot.create(:user, nome: "user", password: "123456" , email: 'user@gmail', cpf: '14214737040') }
        
        it 'editar as informações de um usuário' do
            put "/api/v1/users/#{user.id}", params: { 
                
                user: { 
                    nome: "user", 
                    password: "123456" , 
                    email: 'davi@gmail', 
                    cpf: '14214737040' 
                } 
                
            }, headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
            }

            expect(response).to  have_http_status(:accepted)
            expect(JSON.parse(response.body)).to eq({ 
                "cpf" => "14214737040",
                "email" => "davi@gmail",
                "id" => 1,
                "nome" => "user"
            })  
        end

        it "retornar erro quando o token não for do usuário especificado" do
            delete "/api/v1/users/#{2}", headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
            }

            expect(response).to have_http_status(:unauthorized) 
            expect(JSON.parse(response.body)).to eq({
                "error" => "token inválido para esse usuário"
            })
        end

    end

    describe 'DELETE /user' do
        let!(:user) { FactoryBot.create(:user, nome: "luiz davi", password: "123456" , email: 'luiz@gmail', cpf: '85213043070') }

        it 'deletando um usuário do banco' do
            expect {
                delete "/api/v1/users/#{user.id}", headers: { 
                    "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
                }
            }.to change { User.count }.from(1).to(0)

            expect(response).to have_http_status(:no_content)
        end

        it "retornar erro quando o token não for do usuário especificado" do
            delete "/api/v1/users/#{2}", headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
            }

            expect(response).to have_http_status(:unauthorized) 
            expect(JSON.parse(response.body)).to eq({
                "error" => "token inválido para esse usuário"
            })
        end

        it "retornar erro quando o token for inválido" do
            delete "/api/v1/users/#{user.id}", headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3j" 
            }

            expect(response).to have_http_status(:unauthorized)
        end
    end
end
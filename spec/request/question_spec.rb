require 'rails_helper'

RSpec.describe "Questions RESOURCES", type: :request do

    describe "GET /questions" do
        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, name: "qual o nome da nossa galaxia?", formulary_id: form.id, type_question: "text") }
        let!(:question2) { FactoryBot.create(:question, name: "qual o nome da constelação mais próxima da nossa galaxia?", formulary_id: form.id, type_question: "text") }

        it "listando todas as perguntas" do
            get "/api/v1/questions"

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to eq([
                {
                    "id"=>1,
                    "name"=>"qual o nome da nossa galaxia?",
                    "formulary"=>"Space",
                    "type_question"=>"text"
                },
                {
                    "id"=>2,
                    "name"=>"qual o nome da constelação mais próxima da nossa galaxia?",
                    "formulary"=>"Space",
                    "type_question"=>"text"
                }
            ])
        end
    end

    describe "POST /questions" do
        let!(:user) {FactoryBot.create(:user, name: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}
        let!(:form) { FactoryBot.create(:formulary, title: "Game Of Thrones") }
        let!(:question) { FactoryBot.create(:question, name: "qual o nome da familia dos dragões?", formulary_id: form.id, type_question: "text") }

        
        it "criando pergunta" do
            expect{
                post "/api/v1/questions", params: { 
                    formulary_id: form.id,
                    question: { 
                        name: "qual o apelido Tyrion?",  
                        type_question: "text",
                        
                    } 
                }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }
            }.to change { Question.count }.from(1).to eq(2)

            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq({
                "id" => 2,
                "name"=> "qual o apelido Tyrion?",
                "formulary"=> "Game Of Thrones",
                "type_question"=> "text"
            }) 
        end

        it "criando pergunta com imagem" do
            expect{
                post "/api/v1/questions", params: { 
                    formulary_id: form.id,
                    image: "/home/luiz/Imagens/tyrion.jpg",
                    question: { 
                        name: "qual o apelido Tyrion?",  
                        type_question: "image",
                    } 
                }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }
            }.to change { Question.count }.from(1).to eq(2)


        end

        it "retornando erro de pergunta ja existente para esse formulário" do
            post "/api/v1/questions", params: { 
                formulary_id: form.id,
                question: { 
                    name: "qual o nome da familia dos dragões?",  
                    type_question: "text" 
                } 
            }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }

            expect(response).to have_http_status(:method_not_allowed)
            expect(JSON.parse(response.body)).to eq({
                "error" => "questão já existente para esse formulário"
            }) 
        end

        it "retornar erro quando o formulario estiver faltando" do
            post "/api/v1/questions", params: {
                 question: {    
                    name: "qual o nome da familia dos dragões?",  
                    type_question: "text" 
                }  
            }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "Couldn't find Formulary without an ID"
            })
        end

        it "retornar erro quando o as informações da questão estiverem faltando" do
            post "/api/v1/questions", params: { 
                formulary_id: form.id,
            }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }

           expect(response).to have_http_status(:unprocessable_entity)
           expect(JSON.parse(response.body)).to eq({
               "error" => "param is missing or the value is empty: question\nDid you mean?  action\n               controller\n               formulary_id"
           })
        end
    end

    describe "PUT /questions" do
        let!(:user) {FactoryBot.create(:user, name: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}

        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, name: "qual o nome da nossa galaxia?", formulary_id: form.id, type_question: "text") }
        
        it "atualizar as informações de uma pergunta" do
            put "/api/v1/questions/#{question.id}", params: { question: { type_question: "photo" }}, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }

            expect(response).to have_http_status(:accepted)
            expect(JSON.parse(response.body)).to eq({
                "id" => 1,
                "formulary" => "Space",
                "name" => "qual o nome da nossa galaxia?",
                "type_question" => "photo"

            })
        end

        it "retornar erro de parametros faltando" do
            put "/api/v1/questions/#{form.id}", params: {}, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "param is missing or the value is empty: question\nDid you mean?  action\n               controller\n               id"            
            })
        end

        it "retornar erro ao não encontrar a questão" do
            delete "/api/v1/questions/#{question.id + 1}", headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "Couldn't find Question with 'id'=2 [WHERE \"questions\".\"deleted_at\" IS NULL]"
            })
        end
    end

    describe "DELETE /questions" do
        let!(:user) {FactoryBot.create(:user, name: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}

        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, name: "qual o nome da nossa galaxia?", formulary_id: form.id, type_question: "text") }
        
        it "apagar uma question" do
            expect {
                delete "/api/v1/questions/#{question.id}",headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }
            }.to change { Question.count }.from(1).to eq(0)

            expect(response).to have_http_status(:no_content)
            expect( Question.only_deleted.count ).to eq(1)
            expect( Question.only_deleted[0].name ).to eq("qual o nome da nossa galaxia?")
        end

        it "retornar erro ao não encontrar o formulário" do
            delete "/api/v1/questions/#{question.id + 1}", headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "Couldn't find Question with 'id'=2 [WHERE \"questions\".\"deleted_at\" IS NULL]"
            })
        end
    
    end
end
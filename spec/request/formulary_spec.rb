require "rails_helper"

describe "Formulary RESOURCES", type: :request do

    describe "GET /formularies" do
        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, nome: "qual o nome da nossa galaxia?", formulary_id: form.id, tipo_pergunta: "text") }
        let!(:question2) { FactoryBot.create(:question, nome: "qual o nome da constelação mais próxima da nossa galaxia?", formulary_id: form.id, tipo_pergunta: "text") }

        it 'listar todos os formulário' do
            get "/api/v1/formularies"

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to eq([
                {
                    "id"=>1,
                    "title"=>"Space",
                    "questions"=>[
                        {
                            "question"=>"qual o nome da nossa galaxia?", 
                            "tipo_pergunta"=>"text"
                        },
                        {
                            "question"=>"qual o nome da constelação mais próxima da nossa galaxia?",
                            "tipo_pergunta"=>"text"
                        }
                    ]
                }
            ])
        end
    end

    describe "POST /formularies" do
        let!(:user) {FactoryBot.create(:user, nome: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}

        it "criar um formulário" do
            post "/api/v1/formularies", params: { 
                formulary: { title: "CS Go" },
                questions: [
                    { nome: "qual o nome do time vencedor do major de 2021?", tipo_pergunta: "text" },
                    { nome: "qual o nome do melhor awper do mundo?", tipo_pergunta: "text" },
                ]
            }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }

            expect(response).to have_http_status(:created)
            expect( Formulary.count ).to eq(2)
            expect( Question.count ).to eq(2)
            expect(JSON.parse(response.body)).to eq({
                "id" => 2,
                "title" => "CS Go",
                "questions" => [
                    {
                        "question"=>"qual o nome do time vencedor do major de 2021?", 
                        "tipo_pergunta"=>"text"
                    }, 
                    {
                        "question"=>"qual o nome do melhor awper do mundo?", 
                        "tipo_pergunta"=>"text"
                    }
                ]
            })
        end

        it 'retornar um erro de parametros faltando' do
            post "/api/v1/formularies", params: {},  headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "param is missing or the value is empty: formulary\nDid you mean?  controller\n               action"
            })
        end

        let!(:form) { FactoryBot.create(:formulary, title: "Space") }

        it 'retornar um erro de title ja existente' do
            post "/api/v1/formularies", params: { formulary: { title: "Space" } }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "Validation failed: Title has already been taken"
            })
        end
    end
    
    describe "PUT /formularies" do
        let!(:user) {FactoryBot.create(:user, nome: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}

        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, nome: "qual o nome da nossa galaxia?", formulary_id: form.id, tipo_pergunta: "text") }
        let!(:question2) { FactoryBot.create(:question, nome: "qual o nome da constelação mais próxima da nossa galaxia?", formulary_id: form.id, tipo_pergunta: "text") }

        it "editar as informações de um formulário" do
            put "/api/v1/formularies/#{form.id}", params: { 
                formulary: { title: "Outer Space" },
                questions: [
                    { nome: "qual o nome da nossa galaxia?", tipo_pergunta: "text" },
                    { nome: "qual o nome da constelação mais próxima da nossa galaxia?", tipo_pergunta: "text" }
                ]
            }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }

            expect(response).to  have_http_status(:accepted)
            expect(JSON.parse(response.body)).to eq({
                "id"=>1,
                "title"=>"Outer Space",
                "questions"=>[
                    {
                        "question"=>"qual o nome da nossa galaxia?", 
                        "tipo_pergunta"=>"text"
                    },
                    {
                        "question"=>"qual o nome da constelação mais próxima da nossa galaxia?",
                        "tipo_pergunta"=>"text"
                    }
                ]
            })
        end

        it "retornar erro de parametros faltando" do
            put "/api/v1/formularies/#{form.id}", params: {}, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }


            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error"=>"param is missing or the value is empty: formulary\nDid you mean?  controller\n               action\n               id"
            })
        end
    end

    describe "DELETE /forlumaries" do
        let!(:user) {FactoryBot.create(:user, nome: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}

        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, nome: "qual o nome da nossa galaxia?", formulary_id: form.id, tipo_pergunta: "text") }
        let!(:question2) { FactoryBot.create(:question, nome: "qual o nome da constelação mais próxima da nossa galaxia?", formulary_id: form.id, tipo_pergunta: "text") }

        it "remover um resgistro de um formulário do banco" do
            expect{
                delete "/api/v1/formularies/#{form.id}", headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }
            }.to change { Formulary.count }.from(1).to eq(0)
            
            expect( Question.count ).to eq(0)
            expect(response).to have_http_status(:no_content)
        end
    end

end
require "rails_helper"

describe "Formulary RESOURCES", type: :request do

    describe "GET /formularies" do
        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, name: "qual o name da nossa galaxia?", formulary_id: form.id, type_question: "text") }
        let!(:question2) { FactoryBot.create(:question, name: "qual o name da constelação mais próxima da nossa galaxia?", formulary_id: form.id, type_question: "text") }

        it 'listar todos os formulário' do
            get "/api/v1/formularies"

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to eq([
                {
                    "id"=>1,
                    "title"=>"Space",
                    "questions"=>[
                        {
                            "question"=>"qual o name da nossa galaxia?", 
                            "type_question"=>"text"
                        },
                        {
                            "question"=>"qual o name da constelação mais próxima da nossa galaxia?",
                            "type_question"=>"text"
                        }
                    ]
                }
            ])
        end
    end

    describe "POST /formularies" do
        let!(:user) {FactoryBot.create(:user, name: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}

        it "criar um formulário" do
            post "/api/v1/formularies", params: { 
                formulary: { title: "CS Go" },
                questions: [
                    { name: "qual o name do time vencedor do major de 2021?", type_question: "image", image: "/home/luiz/Imagens/tyrion.jpg" },
                    { name: "qual o name do melhor awper do mundo?", type_question: "text" },
                ]
            }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }

            expect(response).to have_http_status(:created)
            expect( Formulary.count ).to eq(2)
            expect( Question.count ).to eq(4)
            expect(JSON.parse(response.body)).to eq({
                "id" => 2,
                "title" => "CS Go",
                "questions" => [
                    {
                        "question"=>"qual o name do time vencedor do major de 2021?", 
                        "type_question"=>"image"
                    }, 
                    {
                        "question"=>"qual o name do melhor awper do mundo?", 
                        "type_question"=>"text"
                    }
                ]
            })
        end

        it 'retornar um erro de parametros faltando' do
            post "/api/v1/formularies", params: {},  headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "param is missing or the value is empty: questions\nDid you mean?  action\n               controller"
            })
        end

        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, name: "qual o name da nossa galaxia?", formulary_id: form.id, type_question: "text") }
        let!(:question2) { FactoryBot.create(:question, name: "qual o name da constelação mais próxima da nossa galaxia?", formulary_id: form.id, type_question: "text") }


        it 'retornar um erro de title ja existente' do
            post "/api/v1/formularies", params: { 
                formulary: { title: "Space" },
                questions: [
                    { name: "qual o name da nossa galaxia?", type_question: "text" },
                    { name: "qual o name da constelação mais próxima da nossa galaxia?", type_question: "text" },
                ]
            }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "Validation failed: Title has already been taken"
            })
        end

        it 'retornar erro quando não houver questões' do
            post "/api/v1/formularies", params: { 
                formulary: { title: "CS Go" },
                questions: []
            }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }
            
            expect(response).to have_http_status(:bad_request)
            expect(JSON.parse(response.body)).to eq({
                "error"=> "deve haver pelo menos uma pergunta"
            })
        end
    end
    
    describe "PUT /formularies" do
        let!(:user) {FactoryBot.create(:user, name: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}

        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, name: "qual o name da nossa galaxia?", formulary_id: form.id, type_question: "text") }
        let!(:question2) { FactoryBot.create(:question, name: "qual o name da constelação mais próxima da nossa galaxia?", formulary_id: form.id, type_question: "text") }

        it "editar as informações de um formulário" do
            put "/api/v1/formularies/#{form.id}", params: { 
                formulary: { title: "Outer Space" }
            }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }

            expect(response).to  have_http_status(:accepted)
            expect(JSON.parse(response.body)).to eq({
                "id"=>1,
                "title"=>"Outer Space",
                "questions"=>[
                    {
                        "question"=>"qual o name da nossa galaxia?", 
                        "type_question"=>"text"
                    },
                    {
                        "question"=>"qual o name da constelação mais próxima da nossa galaxia?",
                        "type_question"=>"text"
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
        let!(:user) {FactoryBot.create(:user, name: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}

        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, name: "qual o name da nossa galaxia?", formulary_id: form.id, type_question: "text") }
        let!(:question2) { FactoryBot.create(:question, name: "qual o name da constelação mais próxima da nossa galaxia?", formulary_id: form.id, type_question: "text") }

        it "remover um resgistro de um formulário do banco" do
            expect{
                delete "/api/v1/formularies/#{form.id}", headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }
            }.to change { Formulary.count }.from(1).to eq(0)
            
            expect( Question.count ).to eq(0)
            expect(response).to have_http_status(:no_content)
            expect( Formulary.only_deleted.count ).to eq(1)
            expect( Formulary.only_deleted[0].id ).to eq(1)
            expect( Formulary.only_deleted[0].title ).to eq("Space")
        end

        it "retornar erro ao não encontrar o formulário" do
            delete "/api/v1/formularies/#{form.id + 1}", headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "Couldn't find Formulary with 'id'=2 [WHERE \"formularies\".\"deleted_at\" IS NULL]"
            })
        end
    end

end
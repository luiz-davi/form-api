require "rails_helper"

RSpec.describe "Answers RESOURCES", type: :request do

    describe "GET /answers" do
        let!(:user) {FactoryBot.create(:user, nome: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}

        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, nome: "qual o nome da nossa galaxia?", formulary_id: form.id, tipo_pergunta: "text") }
        let!(:question2) { FactoryBot.create(:question, nome: "qual o nome da constelação mais próxima da nossa galaxia?", formulary_id: form.id, tipo_pergunta: "text") }

        let!(:visit) { FactoryBot.create(:visit, data: "2022-02-27", status: "realizando", checkin_at: "2022-02-08 10:00", checkout_at: nil, user_id: user.id) }

        let!(:answer1) { FactoryBot.create(:answer, content: "via lactea", question_id: question.id, formulary_id: form.id, visit_id: visit.id, answered_at: Date.today) }
        let!(:answer2) { FactoryBot.create(:answer, content: "andromeda", question_id: question2.id, formulary_id: form.id, visit_id: visit.id, answered_at: Date.today) }

        it "listar todas as perguntas" do
            get "/api/v1/answers"

            expect(response).to have_http_status(:ok)     
            expect(JSON.parse(response.body)).to eq([
                {
                    "answered_at"=> Date.today.strftime("%Y-%m-%d"),
                    "content"=>"via lactea",
                    "formulary"=>1,
                    "id"=>1,
                    "question"=>1,
                    "visit"=>1
                },
                {
                    "answered_at"=> Date.today.strftime("%Y-%m-%d"),
                    "content"=>"andromeda",
                    "formulary"=>1,
                    "id"=>2,
                    "question"=>2,
                    "visit"=>1
                }
        ])       
        end
    end

    describe "POST /answers" do
        let!(:user) {FactoryBot.create(:user, nome: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}

        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, nome: "qual o nome da nossa galaxia?", formulary_id: form.id, tipo_pergunta: "text") }
        let!(:question2) { FactoryBot.create(:question, nome: "qual o nome da constelação mais próxima da nossa galaxia?", formulary_id: form.id, tipo_pergunta: "text") }

        let!(:visit) { FactoryBot.create(:visit, data: "2022-02-27", status: "realizando", checkin_at: "2022-02-08 10:00", checkout_at: nil, user_id: user.id) }
        let!(:visit2) { FactoryBot.create(:visit, data: "2050-10-19", status: "realizada", checkin_at: "2022-01-08 10:00", checkout_at: "2022-01-08 10:00", user_id: user.id) }

        it "respondendo uma pergunta de um formulário" do
            expect {
                post "/api/v1/answers", params: {
                    answer: { 
                        content: "via lactea",
                        question_id: question.id,
                        formulary_id: form.id,
                        visit_id: visit.id,
                    },
                    
                }, headers: { 
                    "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
                }
            }.to change { Answer.count }.from(0).to eq(1)

            expect(response).to have_http_status(:created)
            expect( visit.answers[0].content ).to eq("via lactea")
            expect( question.answers[0].content ).to eq("via lactea")
            expect( form.questions.first.answers[0].content ).to eq("via lactea")
            expect(JSON.parse(response.body)).to eq({
                "id" => 1,
                "content" => "via lactea",
                "question" => question.nome,
                "formulary" => form.title,
                "visit" => "2022-02-27",
                "answered_at" => Date.today.strftime("%Y-%m-%d")
            })
        end

        it "retornar erros de parâmetros faltando" do
            post "/api/v1/answers", params: {}, headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "param is missing or the value is empty: answer\nDid you mean?  controller\n               action"
            })
        end
        
        it "retornar erro quando não encontrar umas das entidades que a resposta depende" do
            post "/api/v1/answers", params: {
                answer: { 
                    content: "andromeda",
                    question_id: 3,
                    formulary_id: 2,
                    visit_id: visit.id,
                },
                
            }, headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
            }

            expect(response).to have_http_status(:not_found)
            expect(JSON.parse(response.body)).to eq({
                "error"=> "Validation failed: Formulary must exist, Question must exist"
            })
        end

        it "retornar erro quando a visita já tiver sido realizada" do
            post "/api/v1/answers", params: {
                answer: { 
                    content: "via lactea",
                    question_id: question.id,
                    formulary_id: form.id,
                    visit_id: visit2.id,
                },
                
            }, headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
            }

            expect(response).to have_http_status(:not_acceptable)
            expect(JSON.parse(response.body)).to eq({
                "error" => "visita já realizada, não é mais possível atribuir respostas a ela"
            })  

        end
    end

    describe "POST /responder_formulario" do
        let!(:user) {FactoryBot.create(:user, nome: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}

        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, nome: "qual o nome da nossa galaxia?", formulary_id: form.id, tipo_pergunta: "text") }
        let!(:question2) { FactoryBot.create(:question, nome: "qual o nome da constelação mais próxima da nossa galaxia?", formulary_id: form.id, tipo_pergunta: "text") }

        let!(:visit) { FactoryBot.create(:visit, data: "2022-05-30", status: "realizando", checkin_at: "2022-02-04 10:00", checkout_at: nil, user_id: user.id) }
        
        it "respondendo formulário" do
            expect {
                post "/api/v1/responder_formulario", params: {
                    formulary: form.title,
                    visit: visit.id,
                    answers: [
                        {content: "via lactea"},
                        {content: "andromeda"}
                    ]
                },  headers: { 
                    "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
                }
            }.to change { Answer.count }.from(0).to eq(2)
            
            expect(response).to have_http_status(:created)
            expect( question.answers[0].content ).to eq("via lactea")
            expect( question2.answers[0].content ).to eq("andromeda")
            expect(JSON.parse(response.body)).to eq([
                {
                    "answered_at"=>"2022-02-11",
                    "content"=>"via lactea",
                    "formulary"=>1,
                    "id"=>1,
                    "question"=>1,
                    "visit"=>1
                },
                {
                    "answered_at"=>"2022-02-11",
                    "content"=>"andromeda",
                    "formulary"=>1,
                    "id"=>2,
                    "question"=>2,
                    "visit"=>1
                }
            ])
        end

    end

    describe "PUT /answers" do
        let!(:user) {FactoryBot.create(:user, nome: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}

        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, nome: "qual o nome da galaxya que tem o nome de um animal no meio?", formulary_id: form.id, tipo_pergunta: "text") }

        let!(:visit) { FactoryBot.create(:visit, data: "2022-02-27", status: "realizando", checkin_at: "2022-02-08 10:00", checkout_at: nil, user_id: user.id) }

        let!(:answer) { FactoryBot.create(:answer, content: "via lactea", question_id: question.id, formulary_id: form.id, visit_id: visit.id, answered_at: Date.today) }

        it "editar as informações de uma resposta" do
            put "/api/v1/answers/#{answer.id}", params: {
                answer: {
                    content: "Ursa Major"
                }
            }, headers: {
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
            }

            expect(response).to have_http_status(:accepted)
            expect(JSON.parse(response.body)).to eq({
                "id" => 1,
                "content" => "Ursa Major",
                "question" => "qual o nome da galaxya que tem o nome de um animal no meio?",
                "formulary" => "Space",
                "visit" => "2022-02-27",
                "answered_at" => Date.today.strftime("%Y-%m-%d"),
            })
        end

        it "retornar erro quando não houver parâmetros" do
            put "/api/v1/answers/#{answer.id}", headers: {
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" 
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error"=>"param is missing or the value is empty: answer\nDid you mean?  controller\n               action\n               id"
            })
        end

    end

    describe "DELETE /answers" do
        let!(:user) {FactoryBot.create(:user, nome: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}

        let!(:form) { FactoryBot.create(:formulary, title: "Space") }
        let!(:question) { FactoryBot.create(:question, nome: "qual o nome da galaxya que tem o nome de um animal no meio?", formulary_id: form.id, tipo_pergunta: "text") }

        let!(:visit) { FactoryBot.create(:visit, data: "2022-02-27", status: "realizando", checkin_at: "2022-02-08 10:00", checkout_at: nil, user_id: user.id) }

        let!(:answer) { FactoryBot.create(:answer, content: "via lactea", question_id: question.id, formulary_id: form.id, visit_id: visit.id, answered_at: Date.today) }


        it "deletar uma resposta" do
            expect{
                delete "/api/v1/answers/#{answer.id}"
            }.to change { Answer.count }.from(1).to eq(0)

            expect(response).to have_http_status(:no_content)
            
        end
    end

end
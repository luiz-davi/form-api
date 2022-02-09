require "rails_helper"

RSpec.describe "Visits RESOURCES", type: :request do

    describe "GET /visits" do
        let!(:user) {FactoryBot.create(:user, nome: "luiz", email: "luiz@gmail", password: "123", cpf: "12345678978")}
        let!(:visit_1) { FactoryBot.create(:visit, data: "2022-02-15 10:00:00", status: "pendente", checkin_at: "nil", checkout_at: "nil", user_id: user.id) }
        let!(:visit_2) { FactoryBot.create(:visit, data: "2022-03-10 09:00:00", status: "pendente", checkin_at: "nil", checkout_at: "nil", user_id: user.id) }

        it "listar todas as visitas" do
            get "/api/v1/visits"

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to eq([
                {
                    "chekin_at"=>nil,
                    "chekout_at"=>nil,
                    "data"=>"2022-02-15T10:00:00.000Z",
                    "id"=>1,
                    "status"=>"pendente"
                },
                {
                    "chekin_at"=>nil,
                    "chekout_at"=>nil,
                    "data"=>"2022-03-10T09:00:00.000Z",
                    "id"=>2,
                    "status"=>"pendente"
                }
            ])
        end

    end
    
    describe "POST /visits" do
        let!(:user) {FactoryBot.create(:user, nome: "luiz", email: "luiz@gmail", password: "123", cpf: "12345678978")}


        it "criar uma nova visita" do
            expect{
                post "/api/v1/visits", params: {
                    visit: {
                        data: Date.today,
                        status: "pendente",
                        checkin_at: "nil",
                        checkout_at: "nil"
                    }
                }, headers: { 
                    "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
                }
            }.to change { Visit.count }.from(0).to eq(1)

            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq({
                "id" => 1,
                "data" => "2022-02-09",
                "checkin_at" => nil,
                "checkout_at" => nil,
                "status" => "pendente"
            })
        end

        it 'retornar erro quando a autenticação falhar' do
            post "/api/v1/visits", params: {
                visit: {
                    data:  "2022-02-08 11:30:00",
                    status: "pendente",
                    checkin_at: "nil",
                    checkout_at: "nil"
                }
            }, headers: {}

            expect(response).to have_http_status(:unauthorized)
        end

        it 'retornar erro de parâmetros faltando' do
            post "/api/v1/visits", headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "param is missing or the value is empty: visit\nDid you mean?  controller\n               action"
            })
        end

        it 'retornar quando a data for inválida' do
            
            post "/api/v1/visits", params: {
                visit: {
                    data: "2022-02-08",
                    status: "pendente",
                    checkin_at: "nil",
                    checkout_at: "nil"
                }
            }, headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error"=>"Validation failed: Data inválida"
            })
        end

        it 'retornar erro quando a data de checkin_at for inválida' do
            post "/api/v1/visits", params: {
                visit: {
                    data: Date.today,
                    status: "pendente",
                    checkin_at: "2022-02-10 11:30",
                    checkout_at: "nil"
                }
            }, headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "Validation failed: Checkin at inválido. Maior ou igual a data atual"
            })
        end

        it 'retornar erro quando a data de checkin_at for maior que a data de chekout_at' do
            post "/api/v1/visits", params: {
                visit: {
                    data: Date.today,
                    status: "pendente",
                    checkin_at: "2022-02-10 11:30",
                    checkout_at: DateTime.now
                }
            }, headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error"=> "Validation failed: Checkin at inválido. Maior ou igual a data atual, Checkin at inválido. Data posterior ao checkout_at"
            })
        end

        it 'retornar erro quando a data de checkout_at for anterior a data de checkin_at' do
            post "/api/v1/visits", params: {
                visit: {
                    data: "2100-02-10",
                    status: "pendente",
                    checkin_at: "2022-02-08 11:30",
                    checkout_at: "2022-02-07 9:00"  
                }
            }, headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            }
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error"=> "Validation failed: Checkin at inválido. Data posterior ao checkout_at, Checkout at inválido. Data anterior ao checkin_at"
            })
        end
    end

    describe "PUT /visits" do
        let!(:user) {FactoryBot.create(:user, nome: "luiz", email: "luiz@gmail", password: "123", cpf: "12345678978")}
        let!(:visit) { FactoryBot.create(:visit, data: "2021-07-15", status: "realizando", checkin_at: "2021-07-15 10:00", checkout_at: nil, user_id: user.id) }

        it "atualizar as informações de uma visita" do
            put "/api/v1/visits/#{visit.id}", params: {}, headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            }

            # expect(response).to have_http_status(:cre)
        end
    end

    describe "DELETE /visits" do
    end
end
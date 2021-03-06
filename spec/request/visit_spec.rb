require "rails_helper"

RSpec.describe "Visits RESOURCES", type: :request do

    describe "GET /visits" do
        let!(:user) {FactoryBot.create(:user, name: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}
        let!(:visit_1) { FactoryBot.create(:visit, data: "2022-12-15 10:00:00", status: "pendente", checkin_at: "nil", checkout_at: "nil", user_id: user.id) }
        let!(:visit_2) { FactoryBot.create(:visit, data: "2022-11-10 09:00:00", status: "pendente", checkin_at: "nil", checkout_at: "nil", user_id: user.id) }

        it "listar todas as visitas" do
            get "/api/v1/visits"

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to eq([
                {
                    "checkin_at"=>nil,
                    "checkout_at"=>nil,
                    "data"=>"2022-12-15",
                    "id"=>1,
                    "status"=>"pendente"
                },
                {
                    "checkin_at"=>nil,
                    "checkout_at"=>nil,
                    "data"=>"2022-11-10",
                    "id"=>2,
                    "status"=>"pendente"
                }
            ])
        end

    end
    
    describe "POST /visits" do
        let!(:user) {FactoryBot.create(:user, name: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}


        it "criar uma nova visita" do
            expect{
                post "/api/v1/visits", params: {
                    visit: {
                        data: Date.today,
                        status: "pendente",
                    }
                }, headers: { 
                    "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
                }
            }.to change { Visit.count }.from(0).to eq(1)

            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq({
                "id" => 1,
                "data" => Date.today.strftime("%Y-%m-%d"),
                "checkin_at" => nil,
                "checkout_at" => nil,
                "status" => "pendente"
            })
        end

        it 'retornar erro quando a autentica????o falhar' do
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

        it 'retornar erro de par??metros faltando' do
            post "/api/v1/visits", headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "param is missing or the value is empty: visit\nDid you mean?  controller\n               action"
            })
        end

        it 'retornar quando a data for inv??lida' do
            
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
                "error"=>"Validation failed: Data inv??lida"
            })
        end

        it 'retornar erro quando a data de checkinx_at for inv??lida' do
            post "/api/v1/visits", params: {
                visit: {
                    data: Date.today,
                    status: "pendente",
                    checkin_at: "2050-02-10 11:30",
                    checkout_at: "nil"
                }
            }, headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "Validation failed: Checkin at inv??lido. Maior ou igual a data atual"
            })
        end

        it 'retornar erro quando a data de checkin_at for maior que a data de chekout_at' do
            post "/api/v1/visits", params: {
                visit: {
                    data: Date.today,
                    status: "pendente",
                    checkin_at: "2022-02-09 11:30",
                    checkout_at: "2022-02-08 11:30"
                }
            }, headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error"=> "Validation failed: Checkin at inv??lido. Data posterior ao checkout_at, Checkout at inv??lido. Data anterior ao checkin_at"
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
                "error"=> "Validation failed: Checkin at inv??lido. Data posterior ao checkout_at, Checkout at inv??lido. Data anterior ao checkin_at"
            })
        end
    end

    describe "PUT /visits" do
        let!(:user) {FactoryBot.create(:user, name: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}
        let!(:visit) { FactoryBot.create(:visit, data: "2022-05-15", status: "realizando", checkin_at: "2022-02-08 10:00", checkout_at: nil, user_id: user.id) }

        it "atualizar as informa????es de uma visita" do
            put "/api/v1/visits/#{visit.id}", params: {
                visit: {
                    status: "realizado",
                    checkout_at: "2022-02-08 12:00"
                }
            }, headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            }

            expect(response).to have_http_status(:accepted)
            expect(JSON.parse(response.body)).to eq({
                "id" => 1,
                "data" => "2022-05-15",
                "checkin_at" => "2022-02-08T10:00:00.000-03:00",
                "checkout_at" => "2022-02-08T12:00:00.000-03:00",
                "status" => "realizado"
            })

        end

        it "retornar erro de par??metros faltando" do
            put "/api/v1/visits/#{visit.id}", params: {}, headers: { 
                "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "param is missing or the value is empty: visit\nDid you mean?  id\n               controller\n               action"
            })
        end
    end

    describe "DELETE /visits" do
        let!(:user) {FactoryBot.create(:user, name: "luiz", email: "luiz@gmail", password: "123456", cpf: "85213043070")}
        let!(:visit) { FactoryBot.create(:visit, data: "2022-05-15", status: "realizada", checkin_at: "2022-02-08 10:00", checkout_at: "2022-02-08 12:00", user_id: user.id) }

        it "removendo um registro de visita do banco" do
            expect {
                delete "/api/v1/visits/#{visit.id}", headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w" }
            }.to change { Visit.count }.from(1).to eq(0)

            expect(response).to have_http_status(:no_content)
            expect( Visit.only_deleted.count ).to eq(1)
            expect( Visit.only_deleted[0].id ).to eq(1)
        end
    end

end
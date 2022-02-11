require 'rails_helper'

RSpec.describe "Authentication", type: :request do
    let!(:user) { FactoryBot.create(:user, nome: "luiz davi", password: "123456" , email: 'luiz@gmail', cpf: '85213043070') }

    describe "POST /authenticate" do
        it "autenticando o cliente" do
            post "/api/v1/authenticate", params: { email: user.email, password: "123456" }

            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq({
                'token' => "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            })
        end

        it 'retorna um erro quando o nome estiver faltando' do
            post '/api/v1/authenticate', params: { password: "123456" }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "param is missing or the value is empty: email\nDid you mean?  action\n               password\n               controller"
            })
        end

        it 'retorna um erro quando a senha estiver faltando' do
            post '/api/v1/authenticate', params: { email: user.email }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
                "error" => "param is missing or the value is empty: password\nDid you mean?  action\n               controller\n               email"
            })
        end

        it 'retorna um erro quando a senha estiver errada' do
            post '/api/v1/authenticate', params: { email: 'luiz@gmail', password: "errada" }

            expect(response).to have_http_status(:unauthorized )
        end
    end

end
require "rails_helper"

describe "Formulary RESOURCES", type: :request do

    describe "GET /formularies" do
        let!(:formulary) { FactoryBot.create(:formulary, title: "CS Go") }
        let!(:question) { FactoryBot.create(:question, nome: "qual o nome do time campeão do major 2021?", formulary_id: formulary.id, tipo_pergunta: "text") }
        let!(:question2) { FactoryBot.create(:question, nome: "qual o nome do melhor awper do mundo?", formulary_id: formulary.id, tipo_pergunta: "text") }
    
        it 'retornar todos os formulários' do
            get "/api/v1/formularies"

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to eq([
                {
                    "id"=>formulary.id,
                    "title"=>"CS Go",
                    "questions"=>["qual o nome do time campeão do major 2021?", "qual o nome do melhor awper do mundo?"]
                    
                },
            ])
        end
    
    end

end
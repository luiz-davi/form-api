module Api
    module V1
        class FormulariesController < ApplicationController
            include ActionController::HttpAuthentication::Token
            
            before_action :authenticate_user, only: [:create]
            before_action :check_questions, only: [:create]
            before_action :set_formulary, only: [:update, :destroy]
         
            rescue_from ActionController::ParameterMissing, with: :parameter_missing
            rescue_from ActiveRecord::RecordInvalid, with: :parameter_already_exists
            rescue_from ActiveRecord::RecordNotFound, with: :entety_not_found

            def index
                formularies = Formulary.all

                render json: FormulariesRepresenter.as_json(formularies), status: :ok
            end

            def create
                formulary = Formulary.new(formulary_params)
        
                if formulary.save!
                    save_questions(formulary)

                    render json: FormulariesRepresenter.as_json_entety(formulary), status: :created
                else
                    render json: @formulary.erros, status: :unprocessable_entity
                end

            end

            def update
                if @formulary.update(formulary_params)
                    render json: FormulariesRepresenter.as_json_entety(@formulary), status: :accepted
                else
                    render json: @formulary.erros, status: :unprocessable_entity
                end
            end

            def destroy
                @formulary.destroy

                head :no_content
            end

            private
                def check_questions
                    if params.require(:questions)[0] == ""
                        render json: { error: "deve haver pelo menos uma pergunta" }, status: :bad_request
                    end
                end
                
                # formularies
                def formulary_params
                    params.require(:formulary).permit(:title)
                end

                def set_formulary
                    @formulary = Formulary.find(params[:id])
                end

                # questions
                def save_questions(formulary)
                    questions = params[:questions]
                    
                    questions.each do |quest|
                        # garantindo que n??o haja duas perguntas com a mesma descri????o dentro de um mesmo formul??rio
                        unless formulary.questions.find_by(name: quest[:name])
                            question = Question.create(name: quest[:name], formulary_id: formulary.id, type_question: quest[:type_question])

                            if question.type_question == "image"
                                image = quest[:image]
                                question.image.attach(io: File.open(image), filename: "image.jpg", content_type: "image/jpeg")
                            end
                        end
                    end
                end

                # lan??amento de erros
                def parameter_missing(e)
                    render json: { error: e.message }, status: :unprocessable_entity
                end

                def parameter_already_exists(e)
                    render json: { error: e.message }, status: :unprocessable_entity
                end

                def entety_not_found(e)
                    render json: { error: e.message }, status: :unprocessable_entity
                end
        end
    end
end
module Api
    module V1
        class FormulariesController < ApplicationController
            include ActionController::HttpAuthentication::Token
            
            before_action :authenticate_user, only: [:create, :destroy, :update]
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
                def authenticate_user
                    # Authorization: Bearer <token>
                    token, _options = token_and_options(request)
                    user_id = AuthenticationTokenService.decode(token)

                    User.find(user_id)
                    
                rescue ActiveRecord::RecordNotFound,JWT::DecodeError
                    render status: :unauthorized
                end

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
                        # garantindo que não haja duas perguntas com a mesma descrição dentro de um mesmo formulário
                        unless formulary.questions.find_by(nome: quest[:nome])
                            Question.create(nome: quest[:nome], formulary_id: formulary.id, tipo_pergunta: quest[:tipo_pergunta])
                        end
                    end
                end

                # lançamento de erros
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
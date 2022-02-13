module Api
    module V1
        class QuestionsController < ApplicationController
            include ActionController::HttpAuthentication::Token
            
            before_action :authenticate_user, only: [:create, :destroy, :update]
            before_action :set_form, only: [:create]
            before_action :set_question, only: [:update, :destroy]

            rescue_from ActionController::ParameterMissing, ActiveRecord::RecordNotFound, with: :parameter_missing
            rescue_from ActiveRecord::RecordInvalid, with: :parameter_already_exists
            rescue_from ActiveRecord::RecordNotFound, with: :entety_not_found

            def index
                questions = Question.all

                render json: QuestionsRepresenter.as_json(questions), status: :ok
            end

            def create

                question = Question.new(questions_params.merge(formulary_id: @form.id))

                if question.tipo_pergunta == "image"
                    image = params[:image]
                    question.image.attach(io: File.open(image), filename: "image.jpg", content_type: "image/jpeg")
                end

                if @form.questions.find_by(nome: question.nome).nil?
                    if question.save!
                        render json: QuestionsRepresenter.as_json_entety(question), status: :created
                    end
                else
                    quest = Question.find_by(nome: question.nome)

                    render json: {error: "questão já existente para esse formulário"}, status: :method_not_allowed
                end
            end

            def update
                if @question.update(questions_params)
                    render json: QuestionsRepresenter.as_json_entety(@question), status: :accepted
                else
                    render json: @question.erros, status: :unprocessable_entity
                end
            end

            def destroy
                @question.destroy

                head :no_content
            end

            private

                # autenticação
                def authenticate_user
                    # Authorization: Bearer <token>
                    token, _options = token_and_options(request)
                    user_id = AuthenticationTokenService.decode(token)

                    User.find(user_id)
                    
                rescue ActiveRecord::RecordNotFound,JWT::DecodeError
                    render status: :unauthorized
                end

                # questions
                def questions_params
                    params.require(:question).permit(:nome, :tipo_pergunta, :image)
                end

                def set_question
                    @question = Question.find(params[:id])
                end

                def set_form
                    @form = Formulary.find(params[:formulary_id])
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

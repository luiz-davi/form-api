module Api
    module V1
        class AnswersController < ApplicationController
            include ActionController::HttpAuthentication::Token
            
            before_action :authenticate_user, only: [:create, :update]
            before_action :set_answer, only: [:update, :destroy]

            rescue_from ActionController::ParameterMissing, with: :parameter_missing
            rescue_from ActiveRecord::RecordInvalid, with: :entety_not_found
            
            def index
                answers = Answer.all

                render json: AnswersRepresenter.as_json(answers), status: :ok
            end

            def create
                answer = Answer.new(answers_params.merge(answered_at: Date.today))

                if answer.save!
                    render json: AnswersRepresenter.as_json_entety(answer), status: :created
                else
                    render json: answer.errors, status: :unprocessable_entity
                end
            end

            def update
                if @answer.update(answers_params.merge(answered_at: Date.today))
                    render json: AnswersRepresenter.as_json_entety(@answer), status: :accepted 
                else
                    render json: @answer.erros, status: :unprocessable_entity
                end
            end

            def destroy
                @answer.destroy!

                head :no_content
            end

            private
                # answers
                def answers_params
                    params.require(:answer).permit(:content, :question_id, :formulary_id, :visit_id)
                end

                def set_answer
                    @answer = Answer.find(params[:id])
                end

                # before_actions
                def authenticate_user
                    # Authorization: Bearer <token>
                    token, _options = token_and_options(request)
                    user_id = AuthenticationTokenService.decode(token)

                    User.find(user_id)
                    
                rescue ActiveRecord::RecordNotFound, JWT::DecodeError
                    render status: :unauthorized
                end

                # erros
                def parameter_missing(e)
                    render json: { error: e.message }, status: :unprocessable_entity
                end

                def entety_not_found(e)
                    render json: { error: e.message }, status: :not_found
                end

            
        end
    end
end
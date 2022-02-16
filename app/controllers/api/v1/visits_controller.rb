module Api
    module V1
        class VisitsController < ApplicationController
            include ActionController::HttpAuthentication::Token
            
            before_action :authenticate_user, only: [:create]
            before_action :set_visit, only: [:update, :destroy]

            rescue_from ActionController::ParameterMissing, with: :parameter_missing 
            rescue_from ActiveRecord::RecordInvalid, with: :validates_errors
            rescue_from ActiveRecord::RecordNotFound, with: :entety_not_found

            def index
                visits = Visit.all

                render json: VisitsRepresenter.as_json(visits), status: :ok
            end

            def create
                visit = Visit.new(visits_params.merge(user_id: user.id))
                
                if visit.save!
                    render json: VisitsRepresenter.as_json_entety(visit), status: :created
                else
                    render json: visit.error, status: :unprocessable_entity
                end
            end

            def update
                if @visit.update(visits_params)
                   render json: VisitsRepresenter.as_json_entety(@visit), status: :accepted 
                else
                    render json: @visit.errors, status: :unprocessable_entity
                end
            end

            def destroy
                @visit.destroy

                head :no_content
            end

            private
                

                # visits
                def visits_params
                    params.require(:visit).permit(:data, :status, :checkin_at, :checkout_at)
                end

                def set_visit
                    @visit = Visit.find(params[:id])
                end

                def user
                    token, _options = token_and_options(request)
                    user_id = AuthenticationTokenService.decode(token)

                    User.find(user_id)
                end

                # erros
                def parameter_missing(e)
                    render json: { error: e.message }, status: :unprocessable_entity
                end

                def validates_errors(e)
                    render json: { error: e.message }, status: :unprocessable_entity
                end

                def entety_not_found(e)
                    render json: { error: e.message }, status: :unprocessable_entity
                end
        end
    end
end
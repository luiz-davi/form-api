module Api
    module V1
        class UsersController < ApplicationController
            include ActionController::HttpAuthentication::Token
            
            before_action :check_user, only: [:destroy, :update]
            before_action :set_user, only: [:update, :destroy]

            rescue_from ActiveRecord::RecordInvalid, with: :validates
            rescue_from ActiveRecord::RecordNotFound, with: :entety_not_found
            
            def index
                users = User.all

                render json: UsersRepresenter.as_json(users), status: :ok
            end

            def create
                user = User.new(user_params)

                if user.save!
                    render json: UsersRepresenter.as_json_entety(user), status: :created
                else
                    render json: user.errors, status: :unprocessable_entity
                end
            end

            def update
                if @user.update(user_params)
                    render json: UsersRepresenter.as_json_entety(@user), status: :accepted
                else
                    render json: @user.erros, status: :unprocessable_entity
                end
            end

            def destroy
                @user.destroy

                head :no_content
            end

            private

            def user_params
                params.require(:user).permit(:name, :email, :password, :cpf)
            end

            def set_user
                @user = User.find(params[:id])
            end
            
            def check_user
                token, _options = token_and_options(request)
                user_id = AuthenticationTokenService.decode(token)

                unless user_id == params[:id].to_i
                    render json: {error: "token inválido para esse usuário"}, status: :unauthorized
                end
            end
            
            def validates(e)
                render json: { error: e.message }, status: :unprocessable_entity
            end

            def entety_not_found(e)
                render json: { error: e.message }, status: :unprocessable_entity
            end
        end
    end
end
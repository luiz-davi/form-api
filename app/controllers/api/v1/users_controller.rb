module Api
    module V1
        class UsersController < ApplicationController
            before_action :set_user, only: [:update, :destroy]
            
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
                puts @user.email
                if @user.update(user_params)
                    
                    render json: UsersRepresenter.as_json_entety(@user), status: :accepted
                else
                    puts @user.email
                    render json: @user.errors, status: :unprocessable_entity
                end
            end

            def destroy
                @user.destroy

                head :no_content
            end

            private

                def user_params
                    params.require(:user).permit(:nome, :email, :password, :cpf)
                end

                def set_user
                    @user = User.find(params[:id])
                end

        end
    end
end
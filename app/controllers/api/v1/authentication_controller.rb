module Api
    module V1
        class AuthenticationController < ApplicationController
            class UnauthorizedError < StandardError; end

            rescue_from ActionController::ParameterMissing, with: :parameter_missing
            rescue_from UnauthorizedError, with: :handle_unauthenticated

            def create
                raise UnauthorizedError unless user.authenticate(params.require(:password))

                token = AuthenticationTokenService.get_jwt(user.id)

                render json: { token: token }, status: :created
            end

            private

                def user
                    @user ||= User.find_by(email: params.require(:email))
                end

                def parameter_missing(erro)
                    render json: { error: erro.message }, status: :unprocessable_entity
                end
                
                def handle_unauthenticated(e)
                    head :unauthorized
                end
        end
    end
end

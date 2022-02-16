class ApplicationController < ActionController::API
    before_action :authenticate_user, only: [:destroy, :update]

    
    private

    # autenticação
    def authenticate_user
        # Authorization: Bearer <token>
        token, _options = token_and_options(request)
        user_id = AuthenticationTokenService.decode(token)
        
    rescue ActiveRecord::RecordNotFound,JWT::DecodeError
        render status: :unauthorized
    end
end

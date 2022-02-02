module Api
    module V1
        class FormulariesController < ApplicationController
            def index
                formularies = Formulary.all

                render json: FormulariesRepresenter.as_json(formularies), status: :ok
            end
        end
    end
end
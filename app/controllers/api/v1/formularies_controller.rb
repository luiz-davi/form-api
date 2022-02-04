module Api
    module V1
        class FormulariesController < ApplicationController
            before_action :set_formulary, only: [:update, :destroy]

            rescue_from ActionController::ParameterMissing, with: :parameter_missing
            rescue_from ActiveRecord::RecordInvalid, with: :parameter_already_exists

            def index
                formularies = Formulary.all

                render json: FormulariesRepresenter.as_json(formularies), status: :ok
            end

            def create
                formulary = Formulary.new(formulary_params)
        
                if formulary.save!
                    save_questions(formulary)

                    render json: FormulariesRepresenter.as_json_entety(formulary), status: :created
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
                # formularies
                def formulary_params
                    params.require(:formulary).permit(:title)
                end

                def questions_params
                    params.require(:questions)
                end

                def set_formulary
                    @formulary = Formulary.find(params[:id])
                end

                # questions
                def save_questions(formulary)
                    questions_params.each do |questions|
                        # garantindo que não haja duas perguntas com a mesma descrição dentro de um mesmo formulário
                        unless formulary.questions.find_by(nome: questions[:nome])
                            Question.create(nome: questions[:nome], formulary_id: formulary.id, tipo_pergunta: questions[:tipo_pergunta])
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

        end
    end
end
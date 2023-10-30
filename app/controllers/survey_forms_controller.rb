# frozen_string_literal: true

class SurveyFormsController < ApplicationController
  before_action :authorize_form, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @forms = pagy(policy_scope(Topics::SurveyForm.filter(filter_params).includes(:questions, :mobile_notifications)))
  end

  def show
  end

  def new
    @form = authorize Topics::SurveyForm.new
  end

  def create
    @form = authorize Topics::SurveyForm.new(form_params)

    if @form.save
      redirect_to survey_forms_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @form.update(form_params)
      redirect_to survey_forms_url
    else
      render :edit
    end
  end

  def destroy
    @form.destroy

    redirect_to survey_forms_url
  end

  private
    def form_params
      params.require(:topics_survey_form).permit(
        :name_km, :name_en, :tag_list, :description,
        sections_attributes: [
          :id, :name, :_destroy, :display_order,
          questions_attributes: [
            :id, :name, :type, :required, :display_order, :code, :tracking,
            :_destroy, :hint, :relevant, :audio, :remove_audio, :tag_list,
            options_attributes: [:id, :name, :value, :image, :remove_image, :_destroy, chat_group_ids: []],
            criterias_attributes: %i[id question_code operator response_value _destroy]
          ]
        ]
      )
    end

    def authorize_form
      @form = authorize Topics::SurveyForm.find(params[:id])
    end

    def filter_params
      params.permit(:name)
    end
end

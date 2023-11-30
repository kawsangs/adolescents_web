module AppUsers::NotifiableMessageConcern
  extend ActiveSupport::Concern

  included do
    def profile_html
      return "#{I18n.t('app_user.app_user')}: #{I18n.t('app_user.anonymous')}" if anonymous?

      "#{I18n.t('app_user.app_user')}: \n" +
      "#{I18n.t('app_user.gender')}: <b>" + I18n.t("app_user.#{gender}") + "</b>, " +
      "#{I18n.t('app_user.age')}: <b>#{age}</b>, " +
      "#{I18n.t('app_user.province')}: <b>#{province.name_km}</b>, " +
      "#{I18n.t('app_user.occupation')}: <b>" + I18n.t("app_user.#{occupation}") + "</b>, " +
      "#{I18n.t('app_user.education_level')}: <b>" + I18n.t("app_user.#{education_level}") + "</b>, " +
      "#{I18n.t('app_user.characteristic')}: <b>#{characteristics.map(&:name_en).join(', ') || '_'}</b>"
    end
  end
end

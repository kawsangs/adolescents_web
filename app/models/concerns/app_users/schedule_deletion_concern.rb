module AppUsers::ScheduleDeletionConcern
  extend ActiveSupport::Concern

  included do
    REMOVING_PERIOD = ENV.fetch("REMOVING_PERIOD") { 90 }

    # callback
    after_destroy :schedule_real_destroy
    after_real_destroy :remove_association

    def destroy_with_reason(reason_code = nil)
      AppUser.transaction do
        return errors.add(:reason, "cannot be blank") if reason_code.blank?

        create_app_user_reason(reason_code:) && destroy
      end
    end

    private
      def removing_date
        @removing_date ||= deleted_at + REMOVING_PERIOD.days
      end

      def schedule_real_destroy
        AppUserDeletionJob.perform_at(removing_date, id)
      end

      def remove_association
        AppUser.transaction do
          self.visits.destroy_all
          self.app_user_characteristics.destroy_all
          self.surveys.destroy_all
        end
      end
  end
end

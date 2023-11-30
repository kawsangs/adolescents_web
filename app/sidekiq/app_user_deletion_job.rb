class AppUserDeletionJob
  include Sidekiq::Job

  def perform(app_user_id)
    user = AppUser.with_deleted.find(app_user_id)
    user.really_destroy!
  end
end

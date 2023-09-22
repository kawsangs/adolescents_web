module ChatGroupsHelper
  def chat_group_status(chat_group)
    return "<span class='badge bg-secondary' data-bs-toggle='tooltip' title='Telegram bot is changed!'>Deactivated</span>" if chat_group.telegram_bot.nil?
    return "<span class='badge bg-secondary' data-bs-toggle='tooltip' title='Telegram bot is removed from the group!'>Inactived</span>" if !chat_group.active?

    "<span class='badge bg-success'>Active</span>"
  end
end

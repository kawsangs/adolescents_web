module MobileNotificationImportersHelper
  def platform_icon(platform)
    return  icon_android + "<span class='me-1'></span>" + icon_ios unless platform.present?

    send("icon_#{platform}")
  end

  private
    def icon_ios
      '<i class="fa-brands fa-apple"></i>'
    end

    def icon_android
      '<i class="fa-brands fa-android"></i>'
    end
end

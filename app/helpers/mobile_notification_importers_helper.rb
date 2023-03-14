module MobileNotificationImportersHelper
  def platform_icon(platform)
    return  icon_android + "<span class='me-1'></span>" + icon_ios unless platform.present?

    send("icon_#{platform}")
  end

  private
    def icon_ios
      "<span data-bs-toggle='tooltip' bs-placement='top' title='iOs'>" +
      "<i class='fa-brands fa-apple ios-icon'></i>" +
      "</span>"
    end

    def icon_android
      "<span data-bs-toggle='tooltip' bs-placement='top' title='Android'>" +
      "<i class='fa-brands fa-android android-icon'></i>" +
      "</span>"
    end
end

module ApplicationHelper
  def online_status(user)
    content_tag :div, user.username, class: "user-#{user.id} #{'online' if user.online?}"
  end
end

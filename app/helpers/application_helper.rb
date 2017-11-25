module ApplicationHelper
  def online_status(user)
    online = user.online? || user == current_user
    content_tag :div, user.username, class: "user-#{user.id} #{'online' if online}"
  end
end

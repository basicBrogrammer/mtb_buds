# frozen_string_literal: true

module UserHelper
  def prof_pic(user, css: '', size: '40x40')
    url = user.avatar.attached? ? url_for(user.avatar) : 'default-prof-pic.png'
    image_tag url, class: css, size: size
  end
end

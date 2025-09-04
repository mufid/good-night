def basic_auth_header(user)
  user_id =
    if user.is_a?(Integer)
      user
    else
      user.id
    end

  "Basic #{Base64.encode64("#{user_id}:")}"
end

mufid = User.find_or_create_by(name: 'mufid')
User.find_or_create_by(name: 'chisato')
User.find_or_create_by(name: 'takina')

date = Time.zone.now.to_date
year, week = date.year,date.cweek

if User.count < 500_000
  to_insert = (1..500_000).map do |number|
    {name: "random-#{number}"}
  end
  User.insert_all(to_insert)
end

if Sleep.count < 1_000_000
  to_insert = (User.pluck(:id)).map do |number|
    {
      user_id: number,
      clocked_in_at: 32.hours.ago,
    }
  end
  Sleep.insert_all(to_insert)

  Sleep.update_all(
         clocked_out_at: Time.zone.now,
         duration_minutes: Arel.sql("extract('epoch' from (clocked_out_at - clocked_in_at)) / 60"),
         week: Arel.sql("extract('week' from clocked_in_at)"),
         year: Arel.sql("extract('year' from clocked_in_at)")
       )
  Sleep.find_each { it.ensure_duration; it.save }
end

if UserFollowing.where(user_id: mufid.id).count < 500_000
  mufid_id = mufid.id
  to_insert = (User.pluck(:id)).map do |number|
    if number == mufid_id
      nil
    else
      {
        user_id: mufid_id,
        user_following_id: number,
      }
    end
  end.compact
  UserFollowing.insert_all(to_insert)
end

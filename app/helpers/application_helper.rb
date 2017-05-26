module ApplicationHelper
  def is_active?(path)
    current_page?(path) ? "active" : ""
  end

  def avatar_picture(gender)
    females = ["ade", "elyse", "jenny", "kristy", "laura", "nan", "rachel", "valeria"]
    males = ["chris", "elliot", "matt", "matthew", "patrick", "steve", "tom"]
    case gender
    when false
      picture = males.sample
    when true
      picture = females.sample
    when nil
      picture = [females + males].sample
    end
    image_tag("avatars/#{picture}")
  end
end

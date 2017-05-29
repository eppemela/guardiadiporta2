module ApplicationHelper
  def is_active?(path)
    current_page?(path) ? "active" : ""
  end

  def avatar_picture(gender, css_class = nil)
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
    image_tag"avatars/#{picture}", class: css_class
  end

  def humanize_seconds(secs)
    [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        "#{n.to_i} #{name}"
      end
    }.compact.reverse.join(' ')
  end
end

module ApplicationHelper

  def full_title(title=yield(:title))
    "#{title} - Tower"
  end
end

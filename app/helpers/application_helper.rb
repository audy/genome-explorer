module ApplicationHelper
  def count_or_empty_string(x)
    x.count.zero? ? '' : x.count
  end
end

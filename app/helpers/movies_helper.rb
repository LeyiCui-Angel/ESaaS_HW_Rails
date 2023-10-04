module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  # toggling the sorting direction:
  def toggle_direction(c)
    (@current_order == c && @current_dir == 'asc') ? 'desc' : 'asc'
  end
end

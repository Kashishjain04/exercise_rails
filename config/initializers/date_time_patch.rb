class DateTime
  def between_exclusive?(start_time, end_time)
    self >= start_time && before?(end_time)
  end
end
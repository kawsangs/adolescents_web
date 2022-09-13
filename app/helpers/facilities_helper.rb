module FacilitiesHelper
  def hour_list
    [[], ["24h", 24]] +
    (0..11).map { |i| [ "#{i}:00 AM", i] } +
    [["12:00 PM", 12]] +
    (1..11).map { |i| [ "#{i}:00 PM", i + 12] }
  end
end

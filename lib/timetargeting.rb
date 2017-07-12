require 'csv'
require 'date'
contents = CSV.open("../event_attendees.csv", headers: true, header_converters: :symbol)

def sort_by_value(hash)
  hash.sort_by { |key, value| value }.reverse
end

hours = Hash.new(0)
weekday = Hash.new(0)
contents.each do |row|
  date = DateTime.strptime(row[:regdate], '%m/%d/%Y %H:%M')
  hours[date.hour] += 1
  weekday[date.wday] += 1
end

hours = sort_by_value(hours)
weekday = sort_by_value(weekday)
week = {'0': 'Sunday', '1': 'Monday', '2': 'Tuesday', '3': 'Wednesday', '4': 'Thursday', '5': 'Friday', '6': 'Saturday' }

time_report = File.open("report.txt", 'w')
time_report.puts "Here are the top 3 registration hours #{hours[0][0]}, #{hours[1][0]}, #{hours[2][0]}"
time_report.puts "Most people registered on #{week[(weekday[0][0]).to_s.to_sym]}"
 

require "csv"
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id, form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")
  filename = "output/thanks_#{id}.html"
  File.open(filename, 'w') do |file|
    file.puts(form_letter)
  end
end

def clean_phonenumber(phonenumber)
  phonenumber = phonenumber.to_s.gsub('.', '').gsub('(', '').gsub(')', '').gsub('-', '').gsub(' ', '').strip
  if phonenumber.length < 10 || phonenumber.length > 11
    return "invalid"
  elsif phonenumber.length == 11 && phonenumber[0] != 1
    return "invalid"
  else
    phonenumber = phonenumber[1..10] if phonenumber.length == 11
    phonenumber[0..2] + '-' + phonenumber[3..5] + '-' + phonenumber[6..9]
  end
end


puts "EventManager Initialized"

contents = CSV.open("../event_attendees.csv", headers: true, header_converters: :symbol)

template_letter = File.read("../form_letter.erb")
erb_template = ERB.new(template_letter)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phonenumber = clean_phonenumber(row[:homephone])
  time = row[:regdate]

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letters(id, form_letter)




end

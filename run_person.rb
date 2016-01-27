require './person'

space_input = <<EOSPACE
Kournikova Anna F F 6-3-1975 Red
Hingis Martina M F 4-2-1979 Green
Seles Monica H F 12-2-1973 Black
EOSPACE

pipe_input = <<EOPIPE
Smith | Steve | D | M | Red | 3-3-1985
Bonk | Radek | S | M | Green | 6-3-1975
Bouillon | Francis | G | M | Blue | 6-3-1975
EOPIPE

comma_input = <<EOCOMMA
Abercrombie, Neil, Male, Tan, 2/13/1943
Bishop, Timothy, Male, Yellow, 4/23/1967
Kelly, Sue, Female, Pink, 7/12/1959
EOCOMMA

# note: I had hoped to be able to process each format
# without knowing the type of the format using a single
# regexp.  However, the reversed order of favorite color
# and date of birth made that impractical.
# the regexp (incomplete) was looking a little like this:
# ^(?<last>\w+)\s*[\s,|]\s*(?<first>\w+)\s*[\s,|]\s*(?<middle>\w)?\s*[\s,|]?\s*(?<gender>(Male|Female|M|F))\s*[\s,|]?\s*

# this requires at least Ruby 1.9, of course, to use named captures

space_regexp = /^(?<last>\w+)\s*(?<first>\w+)\s*(?<middle>\w)\s*(?<gender>(M|F))\s*(?<month>\d+)-(?<day>\d+)-(?<year>\d+)\s*(?<favorite_color>\w+)$/
pipe_regexp = /^(?<last>\w+)\s\|\s(?<first>\w+)\s\|\s(?<middle>\w)\s\|\s(?<gender>(M|F))\s\|\s(?<favorite_color>\w+)\s\|\s(?<month>\d+)-(?<day>\d+)-(?<year>\d+)$/
comma_regexp = /^(?<last>\w+),\s*(?<first>\w+),\s*(?<gender>(Male|Female)),\s*(?<favorite_color>\w+),\s*(?<month>\d+)\/(?<day>\d+)\/(?<year>\d+)$/

Person.initialize_multiple(space_regexp, space_input)
Person.initialize_multiple(pipe_regexp, pipe_input)
Person.initialize_multiple(comma_regexp, comma_input)

puts
puts "Output 1"
puts Person.all_by_gender_and_last_name

puts
puts "Output 2"
puts Person.all_by_date_of_birth

puts
puts "Output 3"
puts Person.all_by_last_name.reverse

# desired output should be:

# Output 1:
# Hingis Martina Female 4/2/1979 Green
# Kelly Sue Female 7/12/1959 Pink
# Kournikova Anna Female 6/3/1975 Red
# Seles Monica Female 12/2/1973 Black
# Abercrombie Neil Male 2/13/1943 Tan
# Bishop Timothy Male 4/23/1967 Yellow
# Bonk Radek Male 6/3/1975 Green
# Bouillon Francis Male 6/3/1975 Blue
# Smith Steve Male 3/3/1985 Red

# Output 2:
# Abercrombie Neil Male 2/13/1943 Tan
# Kelly Sue Female 7/12/1959 Pink
# Bishop Timothy Male 4/23/1967 Yellow
# Seles Monica Female 12/2/1973 Black
# Bonk Radek Male 6/3/1975 Green
# Bouillon Francis Male 6/3/1975 Blue
# Kournikova Anna Female 6/3/1975 Red
# Hingis Martina Female 4/2/1979 Green
# Smith Steve Male 3/3/1985 Red

# Output 3:
# Smith Steve Male 3/3/1985 Red
# Seles Monica Female 12/2/1973 Black
# Kournikova Anna Female 6/3/1975 Red
# Kelly Sue Female 7/12/1959 Pink
# Hingis Martina Female 4/2/1979 Green
# Bouillon Francis Male 6/3/1975 Blue
# Bonk Radek Male 6/3/1975 Green
# Bishop Timothy Male 4/23/1967 Yellow
# Abercrombie Neil Male 2/13/1943 Tan

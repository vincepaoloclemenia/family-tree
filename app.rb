require_relative 'lib/family/family_concerns'
require_relative 'lib/family'
require_relative 'lib/family/mother_wife_concerns'
require_relative 'lib/family/father_husband_concerns'
require_relative 'lib/family/member'

YES_ANSWERS = %w[y yes].freeze

instance = Family.new
puts 'Welcome to Planet of Lengaburu'
puts 'Would you like to get to know or join the family? (y/n/yes/no)'

continue_using_app = gets.strip

def description_from_input_and_output(input, output)
  command = input.split(' ').first

  case command
  when Family::ADD_CHILD
    "You have added new child #{output.name} which made the member count to #{Family::Member.all.count}!"
  when Family::GET_RELATIONSHIP
    "Please meet #{output}"
  when Family::MAKE_COUPLE
    'You have made new couple!'
  when Family::ADD_MEMBER
    'Thanks for inviting people to join us!'
  end
end

while YES_ANSWERS.include? continue_using_app.downcase
  puts "\n\n"
  puts "Please choose from one the ff commands #{Family::COMMANDS} " \
       'followed by the inputs such as name, gender, etc'

  input = gets.strip.gsub(/"/, '')

  output = instance.parse_input_from_cli input

  if output
    puts 'Awesome!'
    puts description_from_input_and_output(input, output)
    puts "\n\n"
    puts 'Would you like to do more?(y/n)'
  else
    puts 'Looks like you entered an invalid input. Would you still like to continue?(y/n)'
  end

  continue_using_app = gets.strip
end

puts 'Thanks for visiting! Bye!'
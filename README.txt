README - Budget Tracker 

Aim: Allow the user to enter their expenses in categories. 
Each category will keep a running total and be saved locally after each session.
A new session will load the current data. 

Concepts learnt: 
- BigDecimal format 
- JSON Read/write 
- Error handlling and validations 
- #at_exit method 
- exit(1) error 
- "%.2f" precision format 

_____________________________________________
Iterations: 

# Stage 1 - Simple budget tracker
# Adds input to array, prints total. 
expenses = []

5.times do 
	puts "What is the amount?"
	expenses << gets.chomp.to_i 
end

total_expenses = expenses.reduce(:+)

puts "You saved #{total_expenses}"
_____________________________________________
#Stage 2 - Categorise expenses 
#Add a category for expenses, store in Hash and print category with it's expense

expenses = Hash.new(0)

puts "Please enter category for expense"
category = gets.chomp.downcase
expenses[category]
puts "Thanks, now enter an expense for #{category}"
expense = gets.chomp.to_i
expenses[category] = expense
puts "OK, so you entered these expenses:"

expenses.each do |k,v| 
	puts "Category: #{k} had a total expense of #{v}"
end
_____________________________________________
#Stage 3 - Adding more than 1 expense to hash 
expenses = Hash.new(0)

while true do 
  puts "Please enter category for expense, or type 'quit' to exit program"
  category = gets.chomp.downcase
  if category == "quit"
	break	
  end
  expenses[category]
  puts "Thanks, now enter an expense for #{category}"
  expense = gets.chomp.to_i
  expenses[category] += expense
end

puts "OK, so you entered these expenses:"

expenses.each do |k,v| 
	puts "#{k} had a total expense of #{v}"
end
_____________________________________________
#Stage 4 - Add verifications and BigDecimal to expense 

require "bigdecimal"
expenses = Hash.new(0)

while true do 
  puts "Please enter category for expense, or type 'quit' to exit program"
  category = gets.chomp.downcase

  # Validate category 
  unless category.length > 2
    puts "Category should be longer than 2 characters! Run program again"
    exit(1)
  end
  
  if category == "quit"
	break	
  end
  expenses[category]
  puts "Thanks, now enter an expense for #{category}"
  expense = gets.chomp.to_i

  #Validate expense 
  begin
     expense = BigDecimal(expense)
  rescue 
    STDERR.puts("Failed to run")
    exit(1)
  end

  expenses[category] += expense
end

puts "OK, so you entered these expenses:"

expenses.each do |k,v| 
	puts "#{k} had a total expense of #{"$%.2f" % v}" #.2f returning rounded down version... 
end
_____________________________________________
#Stage 5 - Save/load expenses to text file 

require "bigdecimal"
require "json"

#Check if a budget sheet exists, if it does, load this, if not, create a new hash 
FILE_PATH = "/tmp/budget_sheet2.json"

expenses = begin
    JSON.parse(File.read(FILE_PATH))
  rescue Errno::ENOENT
    Hash.new(0)
  end

#Since JSON outputs the hash with string values, convert them to BigDecimal. 
expenses.each do |key, value|
    expenses[key] = BigDecimal(value)
end

#Whilst program is running, ask for category and expense, repeat until user quits
while true do 

  puts "Here are your current expenses:"
  expenses.each do |key, value|
    puts "#{key}: $#{"%.2f" % value}"
  end

  puts "Please enter category for expense, or type 'quit' to exit program"
  category = gets.chomp.downcase

  if category == "quit"
    break	
  end

  if expenses[category] == nil
    expenses[category] = 0
  end

  # Validate category 
  unless category.length > 2
    puts "Category should be longer than 2 characters! Run program again"
    exit(1)
  end
    
  puts "Thanks, now enter an expense for #{category}"
  expense = gets.chomp

  #Validate expense 
  begin
     expense = BigDecimal(expense)
  rescue 
    STDERR.puts("Failed to run")
    exit(1)
  end

  expenses[category] += expense
end

#Summary for when user exits loop 
puts "OK, so you entered these expenses:"

expenses.each do |k,v| 
	puts "#{k} had a total expense of #{"$%.2f" % v}" #.2f returning rounded down version... 
end

at_exit do 
  File.write(FILE_PATH, expenses.to_json)
end

_____________________________________________
#STAGE 6 - Refactoring 

require "bigdecimal"
require "json"

#Check if a budget sheet exists, if it does, load this, if not, create a new hash 
FILE_PATH = "/tmp/budget_sheet2.json"

expenses = begin
    JSON.parse(File.read(FILE_PATH))
  rescue Errno::ENOENT
    Hash.new(0)
  end

#Since JSON outputs the hash with string values, convert them to BigDecimal. 
expenses.each do |key, value|
    expenses[key] = BigDecimal(value)
end

#Refactored loop, since it appears twice in program
def expense_summary(expenses)
  expenses.each do |key, value|
    puts "#{key}: $#{"%.2f" % value}"
  end
end

#Whilst program is running, ask for category and expense, repeat until user quits
while true do 

  puts "Here are your current expenses:"
  expense_summary(expenses)

  puts "Please enter category for expense, or type 'quit' to exit program"
  category = gets.chomp.downcase

  if category == "quit"
    break	
  end

  if expenses[category] == nil
    expenses[category] = 0
  end

  # Validate category 
  unless category.length > 2
    puts "Category should be longer than 2 characters! Run program again"
    exit(1)
  end
    
  #Ask user for expense 
  puts "Thanks, now enter an expense for #{category}"
  expense = gets.chomp

  #Validate expense 
  begin
     expense = BigDecimal(expense)
  rescue 
    STDERR.puts("Failed to run, expense entered was not a number, restart program")
    exit(1)
  end

  expenses[category] += expense
end

#Summary for when user exits loop 
puts "OK, so here are your final expenses for today:"
expense_summary(expenses)

at_exit do 
  File.write(FILE_PATH, expenses.to_json)
end
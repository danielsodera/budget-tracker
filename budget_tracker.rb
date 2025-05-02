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
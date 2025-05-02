=begin
# Stage 1 - Simple budget tracker
# Adds input to array, prints total. 
expenses = []

5.times do 
	puts "What is the amount?"
	expenses << gets.chomp.to_i 
end

total_expenses = expenses.reduce(:+)

puts "You saved #{total_expenses}"
=end

#Stage 2 - Categorise expenses 
#Add a category for expenses, store in Hash and print category with it's expense

=begin
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
=end

#Stage 3 - Adding more than 1 expense to hash 
=begin
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
=end

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
	puts "#{k} had a total expense of #{"$%.2f" %v}" #.2f returning rounded down version... 
end
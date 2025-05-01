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
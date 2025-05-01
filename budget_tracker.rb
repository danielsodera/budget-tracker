
expenses = []

5.times do 
	puts "What is the amount?"
	expenses << gets.chomp.to_i 
end

total_expenses = expenses.reduce(:+)

puts "You saved #{total_expenses}"



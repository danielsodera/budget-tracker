
def ask_for_expense
	puts "Add your expense, and hit enter to save it!"
	expense = gets.chomp 
end

response = ""

until response == "no" do 
	ask_for_expense
	puts "Done with adding your expenses? Write 'no' to end"
	response = gets.chomp
end


require 'console_splash'
require 'colorize'
require 'catpix'

# Creates a new 2d array of width 'width' and height 'height' filled with
# random colour symbols
def get_board(width, height)
	colours = [:red, :blue, :green, :yellow, :cyan, :magenta]
	board = Array.new(height){Array.new(width, :red)}
	board.map! do |x|
		x.map! do |y|
			y = colours.sample
		end
	end
	return board
end

# Displays the splash screen, waits for input and then proceeds to the main
# menu
def splash_screen()
	splash = ConsoleSplash.new()
	splash.write_header("Flood It", "Daniel Marshall", "0.1.0",
			{:nameFg=>:red})
	splash.write_center(-5, "Copyright 2016-")
	splash.write_top_pattern("/\\", {:fg=>:blue})
	splash.write_bottom_pattern("\\/", {:fg=>:blue})
	splash.write_vertical_pattern("|", {:fg=>:blue})
	puts("\e[H\e[2J")
	splash.splash
	width = 14
	height = 9
	best_score = 0
	gets
	main_menu(width, height, best_score)
end

# Displays the main menu, waits for input and then performs an action based
# on the selected option
def main_menu(width, height, best_score)
	puts("\e[H\e[2J")
	puts "Main menu:"
	puts "s = Start game"
	puts "c = Change size"
	puts "q = quit"
	# Prints the best score achieved so far on the current board size
	if best_score == 0
		puts "No games played yet."
	else
		print "Best game: "
		print best_score
		puts " turns"
	end
	input = gets.to_s.chomp
	case input
	# Initalises the score and completion and starts a new game
	when "s"
		score = 0
		completion = 0
		board = get_board(width, height)
		play_game(width, height, board, best_score, score, completion)
	# Moves to the change size method
	when "c"
		change_size(width, height, best_score)
	# Quits the program
	when "q"
		puts "Thank you for playing!"
		exit
	# If input is invalid, asks for input again
	else
		puts "Invalid input."
		main_menu(width, height, best_score)
	end
end

# Takes input for a new width and height and changes the board size, then
# returns to main menu
def change_size(width, height, best_score)
	print "What is your new width? "
	input = gets.chomp.to_i
	width = input
	print "What is your new height? "
	input = gets.chomp.to_i
	height = input
	best_score = 0
	main_menu(width, height, best_score)
end
	
# The main method for gameplay
def play_game(width, height, board, best_score, score, completion)
	active = board[0][0]
	counter = 0
	puts("\e[H\e[2J")
	# Prints the coloured tiles that make up the board using the
	# randomised array
	board.each do |x|
		x.each do |y|
			print "  ".colorize(:background => y)
			if y == active
				counter = counter + 1
			end
		end
	puts
	end
	# Calculates the completion percentage using the counter of
	# coloured cells
	completion = (counter * 100) / (width*height)
	# If completion is 100%, the game is won! Print win message
	# and change best score, then return to menu
	if completion == 100
		print "You won after "
		print score
		puts " turns"
		gets
		if score < best_score || best_score == 0
			best_score = score
		end
		main_menu(width, height, best_score)
	# Print turns and completion and ask for input
	else
		print "Number of turns: "
		puts score
		print "Current completion: "
		print completion 
		puts "%"
		puts board[0][0]
		print "Choose a colour: "
		input = gets.to_s.chomp
		# Quit game if input is q
		if input == "q"
			main_menu(width, height, best_score)
		# Pass the input to a separate method for updating the board,
		# then continue playing the game
		else
			update(board, input)
			score += 1
			play_game(width, height, board, best_score, score, completion)
		end
	end
end

# Use the given input to update the top left cell, then continue to the
# recursive method which decides which other cells to update. (If the input
# is not a valid colour, this method uses up a turn but does nothing else.)
def update(board, input)
	old_colour = board[0][0]
	new_colour = nil
	case input
		when "r"
			new_colour = :red
		when "b"
			new_colour = :blue
		when "g"
			new_colour = :green
		when "c"
			new_colour = :cyan
		when "m"
			new_colour = :magenta
		when "y"
			new_colour = :yellow
		else
			return
		end
	if old_colour == new_colour
		return
	end
	update_cell(board, old_colour, new_colour, 0, 0)
end

# Recursive method - updates the current cell, then checks if all adjacent cells
# need updating (if they exist), and repeats the method using each applicable
# cell
def update_cell(board, old_colour, new_colour, x, y)
	if x+1 <= board.length && y+1 <= board[0].length && y-1 >= -1 && x-1 >= -1
		if board[x][y] != nil && board[x][y] == old_colour 
			board[x][y] = new_colour
			update_cell(board, old_colour, new_colour, x+1, y)
			update_cell(board, old_colour, new_colour, x-1, y)
			update_cell(board, old_colour, new_colour, x, y+1)
			update_cell(board, old_colour, new_colour, x, y-1)
		else
			return
		end
	end
end
	

splash_screen()




require_relative  'BoardObject'

class PrettyPrinter

	def initialize(board_format={
	unknown_cell: '.',
	clear_cell: ' ',
	bomb: '#',
	flag: 'F',
	user_click: 'X'})
		@board_format = board_format
	end

	def print(board_state_objects)
		#puts "PrettyPrinter..."

		board_width = board_state_objects[0].size
		board_height= board_state_objects.size
		col_padding = board_width.to_s.size
		row_padding = board_height.to_s.size + 2

		row_print = " " * row_padding + "|"
		for x in 1..board_width
			#row_print +=  x.to_s.center(col_padding) + "|"
			row_print +=  "%0#{col_padding}d" % x + "|"
		end
		row_print += "\n" + "-" * (row_print.size)
		puts row_print

		for y in 0..board_height-1
			#row_print = (y+1).to_s.center(row_padding) + "|"
			row_print = ("%0#{board_height.to_s.size}d" % (y+1)).center(row_padding) + "|"
			for x in 0..board_width-1
				bs_obj = board_state_objects[y][x]
				#puts "y #{y} x #{x}"
				if bs_obj.is_discovered
					if bs_obj.is_bomb
						row_print += @board_format[:bomb].center(col_padding)
					else
						if bs_obj.is_click
							row_print += @board_format[:user_click].center(col_padding)
						else
							row_print += bs_obj.num_bombs_nearby.to_s.center(col_padding)
						end
					end
				else
					if bs_obj.is_flag
						row_print += @board_format[:flag].center(col_padding)
					else
						if bs_obj.is_xray_active
							if bs_obj.is_bomb
								row_print += @board_format[:bomb].center(col_padding)
							else
								row_print += @board_format[:clear_cell].center(col_padding)
							end
						else
							row_print += @board_format[:unknown_cell].center(col_padding)
						end
					end
				end
				row_print += "|"
				#puts x, y
				#puts "X: #{x} Y: #{y} bs_obj: #{bs_obj.num_pos}"
			end
			#row_print.strip
			#board_state += row_print + "\n"
			puts row_print
		end
		#puts "ending..."
	end
end
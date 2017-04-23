#!/bin/env ruby
# encoding: utf-8

require_relative  'Minesweeper'

class Cell
	attr_reader :row_pos, :col_pos, :num_pos, :is_bomb
	attr_reader :cells_nearby
	attr_reader :is_flag, :is_bomb
	attr_reader :is_click
	attr_writer :is_discovered
	attr_writer :num_bombs_nearby, :cells_nearby
	
	def initialize(col_pos, row_pos, num_pos, is_bomb)
		@row_pos = row_pos
		@col_pos = col_pos
		@num_pos = num_pos
		@is_bomb = is_bomb
		@is_discovered = false
		@is_flag = false
		@is_click = false
		@num_bombs_nearby = 0
		#puts "Inicializando Cell.initialize"
	end

	def num_bombs_nearby
		@num_bombs_nearby
	end

	def is_discovered?
    	@is_discovered
  	end

  	def is_flag?
    	@is_flag
  	end

  	def is_bomb?
    	@is_bomb
  	end

  	def is_click?
    	@is_click
  	end

  	def flag
  		#puts "flagging #{@num_pos} is_discovered #{@is_discovered}"
  		return false if is_discovered?
  		@is_flag = (not @is_flag)
  		return true
  	end

  	def discover()
  		#puts "discovering num pos #{@num_pos} is_discovered #{@is_discovered} is_flag #{@is_flag} is_bomb #{@is_bomb} "
  		return false if is_discovered? or is_flag?
		@is_discovered = true
		@is_click = true
		expand() if not is_bomb? and not is_there_bomb_nerby?
  		return true
  	end




	def is_there_bomb_nerby?
    	@num_bombs_nearby > 0
  	end

  	private

  	def expand()
  		search = lambda {|_cell| not _cell.nil? and not _cell.is_discovered? and not _cell.is_bomb? and not _cell.is_flag?}
  		expand_cells = cells_nearby
  		#puts "expanding cell x,y #{cell.row_pos}, #{cell.col_pos}"
  		until expand_cells.empty? do
  			next_expand_cells = []
  			expand_cells.select{|cell| search.call(cell)}.each do |_cell|
  				#puts "discovering cell x,y #{_cell.row_pos-1s}, #{_cell.col_pos}"
				_cell.is_discovered = true
				# next_expand_cells += _cell.cells_nearby.select{|cell| search.call(cell)} if not _cell.is_there_bomb_nerby?
				next_expand_cells += _cell.cells_nearby if not _cell.is_there_bomb_nerby?
  			end
  			expand_cells = next_expand_cells.compact.uniq
  			# if cell_next_level.nil?
  			# 	puts "next level cell is null, is current the first cell of expansion? #{cell==first}"
  			# 	break if cell == first
  			# 	cell = first
  			# 	next
  			# else
  			# 	puts "expanding next level cell x,y #{cell_next_level.row_pos}, #{cell_next_level.col_pos}"
  			# 	cell = cell_next_level
  			# end
  		end
  		#puts "expanding"
  # 		@cells_nearby.each do |cell|
		# 	if not cell.nil?
		# 		x+=1
		# 		cell.discover(x) 
		# 	end
		# end
  	end
end
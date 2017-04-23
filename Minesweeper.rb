#!/bin/env ruby
# encoding: utf-8

require_relative  'Cell'
require_relative  'BoardObject'
require_relative 'PrettyPrinter'

class Minesweeper
	attr_reader :width, :height, :num_mines
	attr_reader :is_playing, :is_victory
	attr_reader :cells, :cells_mines_rand
	attr_reader :move_number

	TYPE_OF_PLAY = {MOVE: 1, FLAG: 2, BOARD: 3, ENCERRAR: 4}

	def initialize(width, height, num_mines)
		raise ArgumentError, 'Algum dos parametros (width, height ou num_mines) não é numérico' unless width.is_a? Numeric and height.is_a? Numeric and num_mines.is_a? Numeric
		raise ArgumentError, 'Algum dos parametros (width, height ou num_mines) esta faltando' if width.nil? or height.nil? or num_mines.nil?
		raise ArgumentError, 'Algum dos parametros (width, height ou num_mines) é inválido' if width < 1 or height < 1 or num_mines < 1 or width * height <= num_mines
		@width = width
		@height = height
		@num_mines = num_mines
		@is_playing = true
		@is_victory = false
		@is_cells_generated = false
		@move_number = 0
	end

	def play(x, y)
		#puts "play #{x} , #{y}, still playing #{@is_playing}"
		validate_coordinates x, y
  		
  		fill_mines x-1, y-1 if not @is_cells_generated
  		return false if not still_playing?
		
		cell = get_cell(x-1, y-1)
		is_play_valid = cell.discover
		#puts "play is valid? #{is_play_valid}"

		if is_play_valid
			if cell.is_bomb?
				@is_victory = false
				@is_playing = false
			else
				if verify_win_condition
					@is_victory = true
					@is_playing = false
				end
			end
		end
		return is_play_valid
	end

	def flag(x, y)
		#puts "flag #{x} , #{y}"
		validate_coordinates x, y
		cell = get_cell(x-1, y-1)
		is_play_valid = cell.flag
		return is_play_valid
	end

	def still_playing?
		@is_playing
	end

	def victory?
		not @is_playing and @is_victory
	end

	def board_state(xray=false)
		board_state_objects = Array.new(@height) { Array.new(@width) }
		if @is_cells_generated
			@cells.each do |row|
				row.each do |cell|
					#puts "board state row #{cell.row_pos} col #{cell.col_pos} xray #{xray} is_playing #{@is_playing}"
					board_object = BoardObject.new(cell, (xray and not still_playing?))
					#board_object = BoardObject.new(cell, (xray ))
					board_state_objects[cell.row_pos-1][cell.col_pos-1] = board_object
				end
			end
		else
			for x in 0..@height-1
				for y in 0..@width-1
					board_object = BoardObject.new()
					board_state_objects[x][y] = board_object
				end
			end

		end

		return board_state_objects
	end

	def run()
		printer = PrettyPrinter.new()

		until not still_playing?
			next_move_type = type_of_play?
			#puts next_move_type
			case next_move_type #{MOVE: 1, FLAG: 2, BOARD: 3, STATUS: 4}
				when :MOVE
					begin
						auto_print = (not @is_cells_generated)
						
						@move_number += 1
						puts "Movimento ##{@move_number}: x y = "
						move = input

						is_valid_play = play move[0], move[1]
						puts "Jogada inválida" if not is_valid_play

						printer.print(board_state) if auto_print
					rescue StandardError => err
						puts err
						next
					end
				when :FLAG
					puts "Adicionar bandeira: x y = "
					move = input
					is_valid_play = flag move[0], move[1]
					puts "Jogada inválida" if not is_valid_play
				when :BOARD
					if not @is_cells_generated
						puts "Você precisa realizar a primeira jogada antes de visualizar o tabuleiro" 
						next
					end
					printer.print(board_state)
				when :ENCERRAR
					@is_playing = false
			end
		end

		puts "Fim do jogo!"

		if victory?
			puts "Você venceu!"
		else
			puts "Você perdeu! "
			printer.print(board_state(xray: true))
		end
	end

	private

	def validate_coordinates(x, y)
		raise ArgumentError, 'Jogada inválida: algum dos parametros não é numérico' unless x.is_a? Numeric and y.is_a? Numeric
		raise ArgumentError, 'Jogada inválida: posição coluna e/ou linha ultrapassa o limite do tabuleiro' if x < 1 or y < 1 or x > @height or y > @width
	end

	def get_cell(x, y)
		#puts "get cell #{x}, #{y}"
		return nil if x < 0 or y < 0 or x >= @height or y >= @width
		@cells[x][y]
	end

	def type_of_play?
		type_of_play_is_valid = false
		until type_of_play_is_valid do
			print "O que você deseja fazer?\n  (1) Abrir célula (2) Adicionar bandeira (3) Visualizar tabuleiro (4) Encerrar: "
			user_input = Integer(gets)
			#puts "Opção escolhida " + user_input.to_s
			#puts TYPE_OF_PLAY.to_s
			type_of_play_is_valid = TYPE_OF_PLAY.has_value?(user_input)
			#puts TYPE_OF_PLAY.key(user_input)
			if not type_of_play_is_valid
				puts "Opção inválida" 
			else
				return TYPE_OF_PLAY.key(user_input)
			end
		end
	end

	def input
    	x,y = gets.split()
    	#puts "x: #{x}, y: #{y}"
    	x,y = Integer(x), Integer(y)
    	[x, y]
	end

	def verify_win_condition()
		@cells.each do |row|
			row.each do |cell|
				return false if(not cell.is_bomb? and not cell.is_discovered?)
			end
		end
		return true
	end

	def fill_mines(_x, _y)
		randomize_mines(_x, _y)
		
		cell_pos = 1
		@cells =  Array.new(@height) { Array.new(@width) }
		for x in 1..@height
			for y in 1..@width
				#is_bomb = (@cells_mines_rand.include? cell_pos)
				is_bomb = (@cells_mines_rand.include? [x-1,y-1])
				cell = Cell.new(y, x, cell_pos, is_bomb)
				#@cells << cell
				@cells[x-1][y-1] = cell
				#puts "x: #{x} y: #{y} Pos: #{cell_pos} is bomb #{is_bomb}"
				cell_pos += 1
			end
		end

		@cells.each do |row|
			row.each do |cell|
				populate_cells_nearby(cell)
			end
		end

		#puts "fill mines completed..."

		#PrettyPrinter.new.print board_state(true)

		@is_cells_generated = true
	end

	def randomize_mines(x, y)
		#puts "Inicializando Minesweeper.randomize_mines"
		initial_play = [x, y]
		row_indexes = (0..@height-1).to_a
		col_indexes = (0..@width-1).to_a
		@cells_mines_rand = row_indexes.product(col_indexes).shuffle[0..@num_mines]
		if @cells_mines_rand.include? initial_play
			@cells_mines_rand.delete(initial_play)
		else
			@cells_mines_rand.pop
		end
		#@cells_mines_rand = (1..(@width*@height)).to_a.shuffle[0..@num_mines]
		
		# @cells_mines_rand = []
		# until @cells_mines_rand.size == @num_mines do
		# 	random_pos = [rand(@height-1),rand(@width-1)]
		# 	puts "getting random pos mines, total mines generated #{@cells_mines_rand.size}, trying #{random_pos.to_s} must not match #{[x-1, y-1].to_s }"
		# 	next if random_pos == [x-1, y-1] or @cells_mines_rand.include?(random_pos)
		# 	@cells_mines_rand << random_pos
		# end

		#puts "Minas: #{@cells_mines_rand}"
	end

  	def populate_cells_nearby(cell)
		row_index = cell.row_pos - 1
		col_index = cell.col_pos - 1
		
		cells_nearby = []
		cells_nearby << get_cell(row_index-1, col_index-1)
		cells_nearby << get_cell(row_index-1, col_index)
		cells_nearby << get_cell(row_index-1, col_index+1)
		cells_nearby << get_cell(row_index, col_index+1)
		cells_nearby << get_cell(row_index+1, col_index+1)
		cells_nearby << get_cell(row_index+1, col_index)
		cells_nearby << get_cell(row_index+1, col_index-1)
		cells_nearby << get_cell(row_index, col_index-1)
		cell.cells_nearby = cells_nearby

		num_bombs_nearby = 0
		cells_nearby.each do |cell|
			if not cell.nil? and cell.is_bomb?
				#puts "#{cell.num_pos} is nearby bomb"
				num_bombs_nearby += 1
			end
		end
		cell.num_bombs_nearby = num_bombs_nearby
	end

end
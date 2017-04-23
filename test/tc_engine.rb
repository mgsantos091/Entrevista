#!/bin/env ruby
# encoding: utf-8

require_relative  '../Minesweeper'
require "test/unit"

class TestEngine < Test::Unit::TestCase

  def test_typecheck
  	assert_raise( ArgumentError ) { Minesweeper.new('a') }    
  end

  def test_arguments
  	for x in 1..100
  		width, height = rand(10), rand(10)
  		num_mines = rand(height*width)
  		puts "Test Case (Arguments) #{x}: width #{width}, height #{height} e num_mines #{num_mines}}"
  		if width < 1 or height < 1 or num_mines < 1 or width * height <= num_mines
  			assert_raise( ArgumentError ) { Minesweeper.new(width, height, num_mines) }
  		else
  			assert_nothing_thrown {Minesweeper.new(width, height, num_mines)}
  		end
  	end
  end


  def test_lose_condition
  	x = 1
  	until x == 100
  		width, height = rand(10)+1, rand(10)+1
  		width += 1 if width == 1 and height == 1
  		num_mines = rand(height*width)
  		num_mines = num_mines == 0 ? 1 : num_mines
  		
  		puts "Test Case (Lose Condition) #{x}: width #{width}, height #{height} e num_mines #{num_mines}}"
  		
  		game = Minesweeper.new(width, height, num_mines)
  		move = [rand(height)+1, rand(width)+1]
  		valid_move = game.play(move[0], move[1])
  		assert((valid_move),"primeira jogada (X: #{move[0]} Y: #{move[1]}) deve ser sempre válido (assumindo parametros são corretos) ") # 
  		
  		if game.victory? # ignora jogada que ganha de primeira
  			next
  		end

  		random_mine = game.cells_mines_rand[0]
  		game.play random_mine[0]+1, random_mine[1]+1

  		assert( (not game.still_playing? and not game.victory?), "após jogar na posição #{random_mine[0]}, #{random_mine[1]} era esperado a derrota}" )
  		x += 1
  	end
  end

    def test_win_condition
  	x = 1
  	until x == 100
  		width, height = rand(10)+1, rand(10)+1
  		width += 1 if width == 1 and height == 1
  		num_mines = rand(height*width)
  		num_mines = num_mines == 0 ? 1 : num_mines
  		
  		puts "Test Case (Win Condition) #{x}: width #{width}, height #{height} e num_mines #{num_mines}}"
  		
  		game = Minesweeper.new(width, height, num_mines)
  		move = [rand(height)+1, rand(width)+1]
  		valid_move = game.play(move[0], move[1])
  		assert((valid_move),"primeira jogada (X: #{move[0]} Y: #{move[1]}) deve ser sempre válido (assumindo parametros são corretos) ") # 
  		
  		last_move = []
  		until game.victory? and not game.still_playing?
  			move = [rand(height)+1, rand(width)+1]
  			game.play(move[0], move[1]) if game.cells_mines_rand.include? move # joga apenas em locais sem bombas
  			last_move = move
  		end

  		assert( (game.victory?), "após jogar na posição #{last_move[0]}, #{last_move[1]} o jogo foi encerrado sem vitória}" )
  		x += 1
  	end
  end

end

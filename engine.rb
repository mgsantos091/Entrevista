#!/usr/bin/ruby
# encoding: utf-8

require_relative 'Minesweeper'
require_relative 'SimplePrinter'
require_relative 'PrettyPrinter'

width, height, num_mines = 50, 50, 200
game = Minesweeper.new(width, height, num_mines)
game.run
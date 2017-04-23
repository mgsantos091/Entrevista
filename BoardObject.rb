#!/bin/env ruby
# encoding: utf-8

require_relative  'Cell'

class BoardObject
	
	attr_reader :num_bombs_nearby, :is_bomb, :is_click, :is_discovered, :is_flag, :is_xray_active
	attr_reader :row_pos, :col_pos

	def initialize(cell=nil, is_xray_active=false)
		if cell.nil?
			@is_discovered = false
			@is_flag = false
			@is_bomb = false
		else
			@is_discovered = cell.is_discovered?
			@is_flag = cell.is_flag?
			@is_bomb = (
				(cell.is_discovered? or is_xray_active) and
				cell.is_bomb?
			)
			@is_xray_active = is_xray_active
			@num_bombs_nearby = cell.num_bombs_nearby
			@is_click = cell.is_click?
			@row_pos = cell.row_pos
			@col_pos = cell.col_pos
		end
		#puts "BoardObject is_discovered #{is_discovered} is_flag"
	end

	# def initialize(is_discovered, is_flag, is_bomb, is_xray_active, num_bombs_nearby)
	# 	@is_discovered = is_discovered
	# 	@is_flag = is_flag
	# 	@is_bomb = is_bomb
	# 	@is_xray_active = is_xray_active
	# 	@num_bombs_nearby = num_bombs_nearby
	# end

end
require_relative  'BoardObject'

class SimplePrinter
	def print(board_state_objects)
		puts "SimplePrinter (#{board_state_objects.count})..."
		board_state_objects.each do |row|
			row.each do |bs_obj|
			puts "
			  Row: #{bs_obj.row_pos} 
			  Col: #{bs_obj.col_pos} 
			  X-Ray: #{bs_obj.is_xray_active} 
			  Is Bomb?: #{bs_obj.is_bomb} 
			  Is Discovered?: #{bs_obj.is_discovered} 
			  Is Flag?: #{bs_obj.is_flag} 
			  N# Bombs Nearby: #{bs_obj.num_bombs_nearby}"
			end
		end
		puts "ending..."
	end
end
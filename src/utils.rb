module UTILS

	def self.user_input_for_artist_name
		puts "give me name of artist.."
		artist_name = gets.chomp
		artist_name.downcase
	end


	def self.parse_JSON(filename)
		file = File.read(filename)
		data_array = JSON.parse(file)
		data_array
	end


	def self.write_to_file(filename,data_array)
		File.open(filename,"w") do |f|
     		f.puts JSON.pretty_generate(data_array) 
     		puts "data updated"
   		end
   end





	

end
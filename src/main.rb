module MAIN

	require_relative 'Artist'
	require_relative 'UTILS'
	require 'json'

	# most_popular_songs = []
	@@artist_file_path = '/Users/harshita.kapoor/Desktop/Ruby/LIL_practice_scripts/challenge6_music_collection_app_write_to_json_file/data/mycollection.json'
	$data_array = []

	def self.artist_menu
		resp = print_index()
		choices(resp)
		puts "Wish to continue (Y/N)?"
		cont = gets.chomp
		while cont == 'Y'
			resp = print_index()
			choices(resp)
			puts "Wish to continue (Y/N)?"
			cont = gets.chomp
		end
	end


	def self.print_index
		puts "WELCOME TO OUR SONG AND ARTIST COLLECTION FINDER"
		puts "================================================"
		puts "please select an action"
		puts "------------------------------------------------"
		puts "1. Add an artist to collection"
		puts "2. Print all artists in my collection"
		puts "3. Search for artist in our collection"
		puts "4. How many artists in my collection"
		puts "5. Find Number of songs sung by an artist"
		puts "6. Delete a record"
		puts "7. Update total songs in artist record"
		puts "8. Add another popular song by artist"
		resp = gets.chomp
		resp
	end


	def self.choices(resp)

		case resp
		when"1"
			add_new_artist()
		when"2"
			all_artist(@@artist_file_path)
		when "3"
			find_artist(@@artist_file_path)
		when"4"
			how_many_artists_in_my_collection(@@artist_file_path)
		when"5"
			number_of_songs_by_artist(@@artist_file_path)
		when"6"
			delete_a_record(@@artist_file_path)
		when"7"
			update_total_songs(@@artist_file_path)
		when"8"
			add_to_most_popular_song(@@artist_file_path)
		else
			"please make valid choices"
		end
		
	end




	def self.add_new_artist
		collection = []
		artist = Artist.new
		add_artist(artist)
		hash = {}
		artist.instance_variables.each {|var| hash[var.to_s.delete("@")] = artist.instance_variable_get(var) }
		validate_input(hash, @@artist_file_path)
	end



	def self.validate_input(hash, filename)
		valid_name = false
		valid_age = false
		valid_totalSongs = false


		file = File.read(filename)
		data_array = UTILS.parse_JSON(filename)

		validated_hash = {}

		validated_hash[:name] = hash['name'].downcase
		if validated_hash[:name].match('[a-zA-Z]+')
			valid_name = true
		else
			puts "name must contain alphabets only"
			valid_name = false
		end


		if hash['age'].match('^[0-9]*$')
			validated_hash[:age] = hash['age']
			valid_age = true
		else
			puts "age can only contain numbers"
			valid_age = false
		end


		if hash['total_songs'].match('^[0-9]*$')
			validated_hash[:total_songs ] = hash['total_songs']
			valid_totalSongs  = true
		else
			puts "total songs can only contain numbers"
			valid_totalSongs = false
		end

		if valid_name == true && valid_age == true && valid_totalSongs == true
			 data_array << hash
			UTILS.write_to_file(filename, data_array)
		else
			puts "invalid input , data not updated"
		end

	end

	def self.find_artist(filename)
		artist_name = UTILS.user_input_for_artist_name
		data_array = UTILS.parse_JSON(filename)
		record = data_array.select { |d| d["name"] == artist_name }
		puts record	
	end


	def self.how_many_artists_in_my_collection(filename)
		data_array = UTILS.parse_JSON(filename)
		puts "we have #{data_array.size} artists in our collection"
	end


	def self.all_artist(filename)
		data_array = UTILS.parse_JSON(filename)
		puts "================================================================================================="
		puts "Name".ljust(15) + "Age".ljust(10) + "TotalSongs".ljust(15) + "Most Popular Song".ljust(25)
		data_array.each do |data| 
			
			puts data["name"].ljust(15) + data["age"].ljust(10) + data["total_songs"].ljust(15)+ data["most_popular_songs"][0].ljust(25)
			puts "\n"
			# puts "---------------------------------------------------------------------------------------------"
		end
		puts "================================================================================================="

	end

	def self.number_of_songs_by_artist(filename)
		artist = UTILS.user_input_for_artist_name
		data_array = UTILS.parse_JSON(filename)
		record = data_array.find { |d| d["name"] == artist }
		puts "Number of songs sung by #{artist} are #{record["total_songs"]} " if !record.nil?
		puts "we could not find any record for your artist search" if record.nil?
	end


	def self.delete_a_record(filename)
		artist = UTILS.user_input_for_artist_name
		data_array = UTILS.parse_JSON(filename)
		record_index = data_array.find_index { |d| d["name"] == artist }
		if record_index
			if data_array.delete_at(record_index) 
				puts "successfully deleted "
				UTILS.write_to_file(filename, data_array)
			else
				puts "not successfully deleted"
			end
		else
			puts "we could not find record that matches your search"
		end
		
	end



	def self.update_total_songs(filename)
		artist = UTILS.user_input_for_artist_name
		data_array = UTILS.parse_JSON(filename)
		record_index = data_array.find_index { |d| d["name"] == artist }
		if record_index
			puts "give me new updated total songs sung by #{artist}"
			updated_num = gets.chomp
			data_array[record_index]["total_songs"] = updated_num
			UTILS.write_to_file(filename, data_array)
		else
			puts "we could not find record that matches your search"
		end
	end


	def self.add_to_most_popular_song(filename)
		artist = UTILS.user_input_for_artist_name
		data_array = UTILS.parse_JSON(filename)
		record_index = data_array.find_index { |d| d["name"] == artist }
		if record_index
			puts "Add another popular song by #{artist}"
			updated_popular_song = gets.chomp
			data_array[record_index]["most_popular_songs"] << updated_popular_song
			UTILS.write_to_file(filename, data_array)
		else
			puts "we could not find record that matches your search"
		end

	end


	def self.add_artist(artist)

		puts "Name of artist.."
		artist.name = gets.chomp
			
		puts "Age.."
		artist.age = gets.chomp

		puts "Total Songs .."
		artist.total_songs = gets.chomp

		puts "Most popular songs.."
		artist.most_popular_songs << gets.chomp
		puts "Do you have more popular songs to add (Y/N) "
		response = gets.chomp
		while response == "Y"
			puts "ok add more.."
			artist.most_popular_songs << gets.chomp
			puts "Do you have more popular songs to add (Y/N) "
			response = gets.chomp
		end
	end



end




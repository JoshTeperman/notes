# For CSVs
# "r" Read-only, starts at beginning of file (default mode).
# "r+" Read-write, starts at beginning of file.
# "w" Write-only, truncates existing file to zero length or creates a new file for writing.
# "w+" Read-write, truncates existing file to zero length or creates a new file for reading and writing.
# "a" Write-only, starts at end of file if file exists, otherwise creates a new file for writing.
# "a+" Read-write, starts at end of file if file exists, otherwise creates a new file for reading and writing.

require 'csv'
require 'pry'
print "Enter filename: "
filename = gets.chomp + '.csv'

def read_line_by_line(filename)
	CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
		name = row[:name]
		country = row[:country]
		subcountry = row[:subcountry]
		puts "#{name}, #{subcountry}, #{country}"
	end
end

def read_all_at_once(filename)
	puts CSV.read(filename)
end

def write_to(filename)
	CSV.open(filename, "ab") do |csv|
		csv << ["lets", "add", "another", "row"]
		csv << ["and", "again"]
	end
end

# write_to(filename)
read_line_by_line(filename)
# read_all_at_once(filename)

# Reading/Writing in txt files
def get_filename
	print 'Enter filename: '
	filename = gets.chomp
	return filename + ".txt"
end

# txt is NOT the contents of the file. It is a File Object.
def read_in_file(filename)
	puts "Reading File: #{filename}"
	txt = File.open(filename, 'r')
	return txt
end

def display_txt_file(filename)
	txt = read_in_file(filename)
	print txt.read
end

def ask_for_new_word
	print 'Enter word to be added:'
	new_word = gets.chomp
	return new_word
end

def write_to_file(filename)
	new_word = ask_for_new_word
	file = File.open(filename, 'a') do |line|
		line << "\r" + new_word + "\n"
	end
	file.close
end

def test_methods
	filename = get_filename
	write_to_file(filename)
	display_txt_file(filename)
end

test_methods
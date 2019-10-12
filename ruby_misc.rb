#METHOD to 2 decimals -->
def to_2_decimal_places(num)
    return ((num * 100).round(2))/100
end

#returns float to 2 decimal places -->
amount = 0.823625832458
puts "#{'%.2f' % amount}"   

#SEND AND PUBLIC_SEND --->

puts 3.send(:+, 4)
puts 3.send("+", 4)
# whenever we perform a method on an object we are using object.send(message, arguments) to 'send' the message. 
# therefore the above code is the same as puts 3 + 4
# the message will always be either a symbol, or a string
# eg:

public_methods(all=true) #=> return array of all methods accessible to object with public_send

# REGEX ---->

# =~ matches rxp against a string and returns => integer or nil
# "string" !~ /x/ => '=~' operator matches input data against string and returns integer (index) or ~nil
# can also use the .match method for the same purpose which returns the word and nil to console
# RegEx are created using /.../ and %r{...} literals, and by the Regexp::new or Regexp.new constructors
# String interpolation is possible ie: /#{place}/.match("string") where place = "Tokyo"
# Backslash "\" is used as escape. Patterns behave like double-quoted strings so can contain the same backslash escapes. 
/W[aeiou]rd/.match("Word") => Word #/[ab]/ means a or b, as opposed to /ab/ which means a followed by b
/needle/.match('haystack') #=> nil

"This is a string".scan(/[aeiou]/) 
# returns array with all matches it finds ["i", "i", "a", etc]

"string" !~ /\d/ => index / false #check for digit character [0-9]
"string" !~ /\D/ => index / false #check for non-digit character [^0-9] *** tests seem to do the opposite  - "00" !~ /\D/ => true
"string" =~ /\s/ => index / false #check for whitespace character [ \t\r\n\f]
"string" =~ /\S/ => index / false #check for non-whitespace character[^ \t\r\n\f]
"string" =~ /\w/ => index / false #check for a word character [a-zA-Z0-9_]
"string" =~ /\W/ => index / false #check for a non-word character [^a-zA-Z0-9_]
/./ OR /^\n/ # denotes any letter except newline
/\(char)+/ # + denotes at least one (char)
/\(char){n}/ # + denotes exactly n times => {n,} would be n or more times
/(char)*/ #denotes zero or more 
[[:upper]] [[:lower]] # denotes uppercase and lowercase
[[:punc]] # denotes punctuation
"Hello".match(/[[:upper:]]+[[:lower:]]+l{2}o/) #=> #<MatchData "Hello"> at least one uppercase, at least one lowercase, exactly 2 'l' and one 'o'
/0-9a-z/ # hyphen is a metacharacter denoting range, therefore /0-9/ denotes [0123456789]
/a-fy-z/ # a to f, y to z
/[a-w&&[^c-g]z]/ # ([a-w] AND ([^c-g] OR z)) is equivalent to /[abh-w]/ because && intersects the first argument a-w with NOT c-g or z
\b OR \< \># \b denotes boundary, so bookending would denote a word, eg \bcat\b would denote the word "cat", as would \<cat\>
\B # not the boundary (start or end of a word)
^[] # start of line
[]$ # end of line => ^[0-9]$ would match a numeric string (end and start of line are defined)
\A # start of input
\Z # end of input
\n #new line, or line break
/^\s*\n/ # selects lines with nothing on them => '^' from the start of a line '\s*' with any amount of whitespace '\n' to the end of a line
/^ +/ # selects white space at start of a new line => '^' from new line ' +' at least one whitespace

# EACH_CONS METHOD -->

array.each_cons(n) 
# => returns all (n)ngrams for the array called. eg: for array = [0,1,2,3], array.each_cons(3) => [[0,1,2],[1,2,3]]
# use in conjunction with enumerators to perform various tasks:
# eg: use with all? to check if all meet a certain parameter:
array.each_cons(2).all? { |x,y| x == y - 1 } => true / false
# or use .count : This block will count the number of instances in a string where a character is surrounded by the same character, like 'aba':
str = 'abcxyxoefjkfkafojkeflel'
str.chars.each_cons(3).count? { |a,b,c| a == c }

# the implementation for cons_method seems useful: 
# constantle implements a scrolling window through the array by pushing element to the end and shifting when the array reaches a defined max size.
array = []
each do |element|
  array << element
  array.shift     if array.size > n
  yield array.dup if array.size == n
end

# Use modulo to loop through lists continuously
# This example randomises which names are chosen for ingredients
(0..9).each do |i|
  unique_burgers << Hamburger.new(names[i % names.length], patties[i % patties.length], buns[i % buns.length], cheese[i % cheese.length], typical_condiments)
end

# Faker GEM-->

gem install faker
require 'faker'
random_name = Faker::Name.name

# Encription Module -->

require 'digest'
require 'digest/bubblebabble'
require 'base64'

module Encryption
	def encrypt(string)
		Digest::SHA2.hexdigest(string)
    end

    def babble_this_bubble(string)
		Digest::SHA1.bubblebabble(string)
    end

    def secret_secret(string)
        Base64.encode64(string)
    end
    
    def decode(encrypted_password)
        Base64.decode64(encrypted_password)
    end    
end

# -- > Sudoku - calculate the blocks within sudoku

def assemble_blocks(board)
  board.map { |row| row.each_slice(3).to_a }.transpose.flatten.each_slice(9).to_a
end
def contains_all_nine?(section)
  [1,2,3,4,5,6,7,8,9].to_set == section.sort.to_set
end
contains_all_nine?(assemble_blocks(board))

# group_by method
[1, 1, 2, 3, 4, 5, 5, 5, 6].group_by(&:itself)
#  => {1=>[1, 1], 2=>[2], 3=>[3], 4=>[4], 5=>[5, 5, 5], 6=>[6]} 

# Counting the number of unique values in an array using group_by, to_h {&block} and transform_values
counts = collection.group_by(&:itself).to_h { |value, answers| [value, answers.count] }
# --> Using the transform_values method to iterate throught he hash and return the counted values
collection.group_by(&:itself).transform_values(&:count)




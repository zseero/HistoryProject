class Term

end

class Add
	def self.words
		['add', 'addition']
	end
end

class Subtract
	def self.words
		['sub', 'subtract', 'take']
	end
end

class Seperator
	def self.words
		['and', 'by', 'with', ',']
	end
end

class AddSeperator < Seperator
	def self.words
		['plus', '+']
	end
end

class SubtractSeperator < Seperator
	def self.words
		['from', 'minus']
	end
end

class SubtractSeperator < Seperator
	def self.words
		['minus']
	end
end

class ReverseSubtractSeperator < Seperator
	def self.words
		['from']
	end
end
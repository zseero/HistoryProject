def not(o)
	if o.is_a?(TruthFactor)
		o.not!
	else
		!(o)
	end
end

$__ifySucceded__
def ify(t)
	if t.is_a?(TrueClass) || t.is_a?(TruthFactor) && t.truey?
		$__ifySucceded__ = true
		yield
	else
		$__ifySucceded__ = false
	end
end

def elsey
	if !$__ifySucceded__
		yield
	end
end

class TruthFactor
	attr_reader :f
	def initialize(f)
		@f = f
	end
	def not!
		@f = 1.0 - @f
	end
	def equaly?(t)
		@f.equaly? t.f
	end
	def truey?
		@f >= 0.7
	end
	def veryTruey?
		@f > 0.9
	end
	def falsey?
		!truey?
	end
	def veryFalsey?
		@f < 0.4
	end
	def to_s
		"TruthFactor:#{(@f * 100).round}%"
	end
end

class Float
	def equaly?(i)
		nums = [self, i.to_f]
		TruthFactor.new(nums.min / nums.max)
	end
end

class Fixnum
	def equaly?(i)
		to_f.equaly?(i)
	end
end

bool = 2.equaly?(2.5)

ify bool do
	puts bool
end
elsey do
	puts "I failed :( " + bool.to_s
end
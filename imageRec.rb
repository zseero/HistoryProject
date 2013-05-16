Ssquare =
	"0000000000000000
	 0001111111111000
	 0001000000001000
	 0001000000001000
	 0001000000001000
	 0001000000001000
	 0001111111111000
	 0000000000000000"
Striangle =
	"0000000000000000
	 0000000010000000
	 0000000101000000
	 0000001000100000
	 0000010000010000
	 0000100000001000
	 0001111111111100
	 0000000000000000"
Scross =
	"0000000000000000
	 0000000010000000
	 0000000010000000
	 0000111111111000
	 0000000010000000
	 0000000010000000
	 0000000010000000
	 0000000000000000"

def convert(str)
	str.gsub!("\n", '')
	ary = []
	str.split(//).each do |s|
		ary << s.to_i
	end
	ary
end

Square, Triangle, Cross = convert(Ssquare), convert(Striangle), convert(Scross)
RSquare, RTriangle, RCross = [1, 0, 0], [0, 1, 0], [0, 0, 1]

def addNoise(ary, lvl, offset = 0)
	if offset != 0
		a = ((offset / offset.abs) + 1) / 2
		b = (a - 1) * -1
		c = ary.length - 1
		offset.abs.times do
			ary.delete_at(a * c)
			ary.insert(b * c, 0)
		end
	end
	lvl.times do
		ary[Random.rand(0...(ary.length))] = Random.rand(0..1)
	end
	ary
end

require 'ai4r'
require 'win32/sapi5'
$voice = Win32::SpVoice.new

def say(s)
	$voice.Speak(s)
end

def putsay(s)
	puts s
	say s
end

def newNet?(ary)
	printf ary[0] + ' '
	makeNew = gets.chomp[0] == 'y'
	makeNew && ary.length > 1 ? newNet?(ary[1..-1]) : makeNew
end

makeNew = newNet?([
	"Would you like to create a new neural net?",
	"Are you sure?",
	"Do you have your mother\'s permission?",
])

fileName = 'imageRec.neural'

if makeNew
	putsay ("Initiating learning sequence...")
	$net = Ai4r::NeuralNetwork::Backpropagation.new([Square.length, 10, 10, 3])
	times = 400
	times.times do |i|
		{Square => RSquare, Triangle => RTriangle, Cross => RCross}.each do |img, res|
			20.times do
				$net.train(img, res)
			end
		end
		printf "\r#{(i.to_f / times.to_f * 100).round}%%" if i % (times / 50) == 0 || i == times - 1
	end
	putsay "\nLearning Complete."
else
	f = File.open(fileName,'r')
	$net = Marshal.load(f)
end

def maxIndex(ary)
	index = ary.index(ary.max)
	index
end

def myPrint(img, expected)
	amt = 15
	8.times do |i|
		range = ((i * amt) + (i * 2) + i)..(((i + 1) * amt) + (i * 2) + i)
		s = ''; img[range].each {|c| s += (c == 1 ? '*' : ' ')}
		puts s
	end
	res = $net.dup.eval(img)
	mi = maxIndex(res)
	bool = mi == maxIndex(expected)
	dif = res.max - (rdup = res.dup; rdup.delete(res.max); rdup.max)
	difPercent = (dif * 100).round
	roundRes = []; res.each {|r| roundRes << (r * 100).round.to_s + '%'}
	shape = ''
	if mi == maxIndex(RSquare)
		shape = 'Square'
	elsif mi == maxIndex(RTriangle)
		shape = 'Triangle'
	elsif mi == maxIndex(RCross)
		shape = 'Cross'
	end
	puts "#{bool ? 'SUCCESS' : 'FAIL'}, I think it\'s a #{shape}, with a #{difPercent}% difference"
	puts "Data: #{roundRes.join(', ')}"
end

while true
	printf "Noise Level: "
	s = gets.chomp
	noise = s.to_i
	if s == 'save net'
		d = Marshal.dump($net)
		file = File.new(fileName, 'wb')
		file.syswrite d
		file.close
		putsay 'Neural Net Saved'
	end
	#printf "Offset amt: "
	#offset = gets.chomp.to_i
	offset = 0
	myPrint(addNoise(Square.dup, noise, offset), RSquare)
	myPrint(addNoise(Triangle.dup, noise, offset), RTriangle)
	myPrint(addNoise(Cross.dup, noise, offset), RCross)
end
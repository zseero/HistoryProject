$ONice = [
	"i love you",
	"love you",
	"i like you",
	"like you",
	"i love like you",
	"love like you",
	"i really like you",
	"i really love you",
	"i really like love you",
	"really like you",
	"really love you",
	"really like love you",
	"do you want to be my friend",
	"will you be my friend",
	"i think you are awesome",
	"i like your personality",
	"you are a great person",
	"no one else is as good as you",
	"you are amazing",
	"you are so nice",
	"you rock",
	"you just rock",
	"you are so pretty",
	"you are so handsome",
	"i like your look",
	"you look really pretty",
	"you look really handsome",
	"your parents are really nice",
	"i like your mom she is nice",
	"you are great",
	"we will be friends forever",
	"i really like you",
	"you are so smart",
	"you are really smart",
	"i think you rock",
	"you are really amazing",
	"i really love you",
]
$OMean = [
	"i hate you",
	"hate you",
	"i desipise you",
	"despise you",
	"i hate despise you",
	"hate despise you",
	"i really hate you",
	"i really despise you",
	"i really hate despise you",
	"really hate you",
	"really despise you",
	"really hate despise you",
	"what is your problem",
	"no one likes you",
	"you are a freak",
	"go away",
	"you are a jerk",
	"everyone hates you",
	"your parents hate you",
	"you hateful person",
	"you freak of nature",
	"why are you so weird",
	"you idiot",
	"you are an idiot",
	"nobody likes you",
	"i think you are an idiot",
	"i think you are a freak",
	"your mother is so fat",
	"your parents are freaks",
	"you were an accident",
	"your parents had you on accident",
	"you should not be here",
	"why are you such a freak",
	"weirdo",
	"stay away from me",
	"stay back",
	"do not come near me",
	"i never want to see you again",
	"i hope i never see you again",
	"why are you so ugly",
	"you are ugly",
	"your face is so ugly",
	"no one loves you",
	"no one will ever love you",
]

# $ONice = [
# 	"i love you",
# 	"love you",
# 	"i like you",
# 	"like you",
# 	"i love like you",
# 	"love like you",
# 	"i really like you",
# 	"i really love you",
# 	"i really like love you",
# 	"really like you",
# 	"really love you",
# 	"really like love you",
# ]

# $OMean = [
# 	"i hate you",
# 	"hate you",
# 	"i desipise you",
# 	"despise you",
# 	"i hate despise you",
# 	"hate despise you",
# 	"i really hate you",
# 	"i really despise you",
# 	"i really hate despise you",
# 	"really hate you",
# 	"really despise you",
# 	"really hate despise you",
# ]

# $ONice = [
# 	"like",
# 	"love",
# 	"likes",
# 	"loves",
# 	"great",
# 	"fantastic",
# 	"kind",
# 	"nice",
# 	"smart",
# 	"pretty",
# 	"handsome",
# 	"awesome",
# 	"giving",
# 	"not bad",
# ]

# $OMean = [
# 	"ugly",
# 	"no one loves",
# 	"nobody loves",
# 	"hate",
# 	"hates",
# 	"mother ugly",
# 	"mother fat",
# 	"accident",
# 	"freak",
# 	"failure",
# 	"hobo",
# 	"suck",
# 	"stink",
# 	"terrible",
# 	"bad"
# ]

$words = [' ']

def getMax
	nMax = $ONice.max {|a, b| a.split(' ').length <=> b.split(' ').length}
	mMax = $OMean.max {|a, b| a.split(' ').length <=> b.split(' ').length}
	max = [nMax.split(' ').length, mMax.split(' ').length].max
	max > 5 ? max : 5
end

def convert(str)
	str.downcase!
	ary = []
	str.split(' ').each {|s|
		$words << s if !$words.include?(s)
		index = $words.index(s)
		ary << index
	}
	(getMax - ary.length).times {ary << 0}
	puts "#{str} : #{ary.join(',')}"
	ary
end

def convertList(oAry)
	ary = []
	oAry.each {|s| ary << convert(s)}
	ary
end

Nice, Mean = convertList($ONice), convertList($OMean)
RNice, RMean = [1, 0], [0, 1]

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
	# "Are you sure?",
	# "Do you have your mother\'s permission?",
])

fileName = 'meanAndNice.neural'

def getSentence(ary)
	s = []
	ary.each {|i| s << $words[i]}
	s.join(' ')
end

def train(s, res)
	10.times {
		$net.train(s, res)
	}
	printf "\r#{getSentence(s)} : #{res}           "
end

if makeNew
	putsay ("Initiating learning sequence...")
	$net = Ai4r::NeuralNetwork::Backpropagation.new([getMax, 50, 2])
	puts "Neural net created"
	times = 100
	times.times do |i|
		nice = Nice.shuffle.dup
		mean = Mean.shuffle.dup
		for ii in 0...([nice, mean].max.length)
			5.times do
				train(nice[ii], RNice) if nice[ii]
				train(mean[ii], RMean) if mean[ii]
			end
		end
		if i % (times / 50) == 0 || i == times - 1
			puts "\r#{(i.to_f / times.to_f * 100).round}%                                 "
		end
		say "#{(i.to_f / times.to_f * 100).round} percent complete" if i % (times / 4) == 0
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

while true
	printf "Statement: "
	s = gets.chomp
	if s == 'save net'
		d = Marshal.dump($net)
		file = File.new(fileName, 'wb')
		file.syswrite d
		file.close
		putsay 'Neural Net Saved'
	end
	res = $net.eval(convert(s))
	dif = res.max - (rdup = res.dup; rdup.delete(res.max); rdup.max)
	difPercent = (dif * 100).round
	puts (maxIndex(res) == maxIndex(RNice) ? 'Nice' : 'Mean') + " with a #{difPercent}% difference"
	puts "Results: #{res.join(', ')}"
end
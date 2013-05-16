require 'ai4r'
require 'win32/sapi5'
$voice = Win32::SpVoice.new

def say(s)
	#$voice.Speak(s)
end

def putsay(s)
	puts s
	say s
end

putsay ("Initiating learning sequence...")

AI = Ai4r::NeuralNetwork::Backpropagation
net = AI.new([3, 3, 2])

max = 10
times = (max * 20)
100.times do
	times.times do |i|
		a = (i / 2.0).to_i / max
		b = (i / 2.0).to_i % max
		c = i.even? ? a + b : a * b
		input = [a, b, c]
		result = i.even? ? [1, 0] : [0, 1]
		20.times do
	  	net.train(input, result)
	  end
		#puts "#{i} : #{input.join(', ')} - #{result.join(',')}"
	  #percent = (i.to_f / times.to_f * 100)
	  #printf "\r#{percent.round}%% complete\n" if percent % 5 == 0
	  #say "#{percent.round} percent complete" if percent % 25 == 0
	end
end

putsay "\nLearning Complete."

while true
	input = gets.chomp.split(' ')
	ary = []
	input.each {|i| ary << i.to_i}
	res = net.eval(ary)
	bool = res[0].to_f > res[1].to_f
	puts bool.to_s.upcase + ' ' + res[0].round(3).to_s + ' ' + res[1].round(3).to_s
end
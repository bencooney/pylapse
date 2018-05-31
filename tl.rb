#! /bin/ruby
require 'active_support/time'

class Timelapse
	
	@startShutterSpeed = 0
	@startIsoValue = 0
	@startWait = 0
	
	@endShutterSpeed = 0
	@endIsoValue = 0
	@endWait = 0

	@doIncreaseSS = true
	@doIncreaseIso = true
	@doIncreaseWait = true

	def calculateShutterSpeeds(shutterSpeed)
		
		if(shutterSpeed.kind_of?(Array))

			@startShutterSpeed = shutterSpeed[0]
			@endShutterSpeed = shutterSpeed[1]	
			@doIncreaseSS = @startShutterSpeed < @endShutterSpeed

			if(@doIncreaseSS)
				@sSRange = @endShutterSpeed - @startShutterSpeed
			else
				@sSRange = @startShutterSpeed - @endShutterSpeed
			end
		else
			@sSRange = 0
			@startShutterSpeed = shutterSpeed
			@endShutterSpeed = shutterSpeed
		
		end
	end

	def calculateWaitValues(microSecsBetween)
		if(microSecsBetween.kind_of?(Array))

			@startWait = microSecsBetween[0]
			@endWait = microSecsBetween[1]
			@doIncreaseWaits = @startWait < @endWait

			if(@doIncreaseWaits)
				@waitRange = @endWait - @startWait
			else
				@waitRange = @startWait - @endWait
			end
		else
			@waitRange = 0
			@startWait = microSecsBetween
			@endWait = microSecsBetween
		end

	end


	def calculateIsoValues(isoValue)
		if(isoValue.kind_of?(Array))

			@startIso = isoValue[0]
			@endIso = isoValue[1]
			@doIncreaseIso = @startIso < @endIso

			if(@doIncreaseIso)
				@isoRange = @endIso - @startIso
			else
				@isoRange = @startIso - @endIso
			end
		else
			@isoRange = 0
			@startIso = isoValue
			@endIso = isoValue
		end
	end

	def takeSequence(timeAtEnd, microSecsBetweenFrames, shutterSpeed, isoValue, sequence)
	
		timeAtStart = Time.new

		height = 1080
		width = 1920
	

		isEndDateInThePast = timeAtEnd < timeAtStart
		if(isEndDateInThePast)
			timeAtEnd += 1.days
		end

		timeRange = timeAtEnd - timeAtStart

		calculateShutterSpeeds(shutterSpeed)
		calculateIsoValues(isoValue)
		calculateWaitValues(microSecsBetweenFrames)

		puts "
	--------------------------------------------------------------------------------"
		puts "Starting Sequence: #{sequence}"
		puts " Start Time: #{timeAtStart}"	
		puts " Capturing until: #{timeAtEnd}"
		puts " - duration: #{timeRange.round} seconds"
		puts " - pausing from #{@startWait} to #{@endWait} micro-secs between frames"
		puts " - shifting ss from #{@startShutterSpeed} to #{@endShutterSpeed}"
		puts " - shifting iso from #{@startIso} to #{@endIso}"
		i = 0

		
		while(true) do 
			i += 1
			timeNow = Time.new
			if(timeNow > timeAtEnd)
				break
			end

			timeSinceStarted = timeNow - timeAtStart
			portionDone = (timeSinceStarted / timeRange)

			if(@doIncreaseWaits)
				wait = @startWait + (portionDone * @waitRange)
			else
				wait = @startWait - (portionDone * @waitRange)
			end				
			cameraWaitTime = 100						
			scriptWaitTime = wait - cameraWaitTime



			if(@doIncreaseSS)
				speed = @startShutterSpeed + (portionDone * @sSRange)
			else
				speed = @startShutterSpeed - (portionDone * @sSRange)
			end
		
			if(@doIncreaseIso)
				iso = @startIso + (portionDone * @isoRange)
			else
				iso = @startIso - (portionDone * @isoRange)
			end
		
			print "#{sequence}.#{i}: -ss #{speed.to_i} -ISO #{iso.to_i} (#{speed},#{iso}) >> "
			`raspistill -t #{cameraWaitTime} -o image.#{sequence}.#{i}.jpg -p 0,0,#{(width * 0.75).to_i},#{(height*0.75).to_i} -w #{width} -h #{height} -ss #{speed.to_i} -ISO #{iso.to_i}`
			sleep( (1.0/1000.0) * scriptWaitTime )
		end 

		timeNow = Time.new
	
		puts ""
		puts "Finished Sequence: #{sequence} after running for #{((timeNow - timeAtStart) /60).round} minutes"
		puts "  Captured #{i} frames"
	end
end

load 'CleanImagesAway.rb'


t = Time.new();
sunrise = Time.new(t.year,t.month,t.day, 7,35)
sunset =  Time.new(t.year,t.month,t.day,17,7)

dayLength = (sunset - sunrise)
nightLength = 24.hours - dayLength

midday = sunrise + (dayLength / 2)
midnight = sunset + (nightLength / 2)

puts "Starting capture. "
puts "  Sunrise: #{sunrise}"
puts "   Sunset: #{sunset}"
puts "   Midday: #{midday}"
puts " Midnight: #{midnight}"

sr = sunrise
ss = sunset

tl = Timelapse.new()
#                   endtime, 	  wait-between,     ss[start,end],    iso[start,end],   id 
=begin
=end
tl.takeSequence(  sr+2.hours,	   [1000,2000],       [2000,2000],     	[200,55],	'010')
tl.takeSequence(  midday,	      2000,	       [2000,1800],	    55,		'020')
tl.takeSequence(  ss-160.minutes,     2000,	       [1800,1200],         [55,65],	'030')
tl.takeSequence(  ss-90.minutes,   [2000,1000],	       [1200,900],           65,		'031')
tl.takeSequence(  ss-60.minutes,   [1000,500],	       [900,1000],          65,		'032')
tl.takeSequence(  ss-20.minutes,   [500,250],	      [1000,2000],        [65,75],	'033')
tl.takeSequence(  ss,	 	      250,	      [2000,6000],        [75,155],	'034')
tl.takeSequence(  ss+15.minutes,      250,	      [6000,35000],    	 [155,225],	'035')
tl.takeSequence(  ss+40.minutes,      250,	     [35000,100000],   	 [225,550],	'036') 
tl.takeSequence(  ss+70.minutes,   [250,500],	    [100000,700000],  	 [550,1275],	'037')
tl.takeSequence(  ss+110.minutes,  [500,1000],	    [700000,1200000],	[1275,1400],	'038')
tl.takeSequence(  midnight,	   [1000,5000],   [1200000,2000000], 	[1400,4000],	'040')
tl.takeSequence(  sr-240.minutes, [5000,10000],   	2000000, 	   4000,	'050')
tl.takeSequence(  sr-120.minutes, [10000,10000],   	2000000, 	[4000,1600],	'055')
tl.takeSequence(  sr-60.minutes,  [10000,1000],     	2000000, 	[1600,1300],	'060')
tl.takeSequence(  sr,  		   1000,	   [2000000,8000],    	[1300,600],	'070')
tl.takeSequence(  sr+45.minutes,   [1000,2000],	      [8000,800],      	 [600,55],	'080')
tl.takeSequence(  midday,	   2000,	       [900,650],	    55,		'090')
tl.takeSequence(  ss-160.minutes,     2000,	       [650,600],         [55,65],	'100')
tl.takeSequence(  ss-90.minutes,   [2000,1000],	       [600,700],           65,		'131')
tl.takeSequence(  ss-60.minutes,   [1000,500],	       [700,1000],          65,		'132')
tl.takeSequence(  ss-20.minutes,   [500,250],	      [1000,2000],        [65,75],	'133')
tl.takeSequence(  ss,	 	      250,	      [2000,6000],        [75,155],	'134')
tl.takeSequence(  ss+15.minutes,      250,	      [6000,35000],    	 [155,225],	'135')
tl.takeSequence(  ss+40.minutes,      250,	     [35000,100000],   	 [225,550],	'136') 
tl.takeSequence(  ss+70.minutes,   [250,500],	    [100000,700000],  	 [550,1275],	'137')
tl.takeSequence(  ss+110.minutes,  [500,1000],	    [700000,1200000],	[1275,1400],	'138')
tl.takeSequence(  midnight,	   [1000,5000],   [1200000,2000000], 	[1400,4000],	'140')
tl.takeSequence(  sr-240.minutes, [5000,10000],   	2000000, 	   4000,	'150')
tl.takeSequence(  sr-120.minutes, [10000,10000],   	2000000, 	[4000,1600],	'155')
tl.takeSequence(  sr-60.minutes,  [10000,1000],     	2000000, 	[1600,1300],	'160')
tl.takeSequence(  sr,  		   1000,	   [2000000,8000],    	[1300,600],	'170')
tl.takeSequence(  sr+45.minutes,   [1000,2000],	      [8000,800],      	 [600,55],	'180')
tl.takeSequence(  midday,	   2000,	       [900,650],	    55,		'190')

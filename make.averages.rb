require 'pathname'


def buildFileNameArray(counter, inFileName, numOfFiles)
	k = counter
	files = []
	numOfFiles.times do |i|
		thisFileName = "#{inFileName}.#{k+i}.jpg"
		if(Pathname(thisFileName).exist?)
			files[i] = thisFileName
		end
	end
	return files
end

def compositeBatchesOfSeven(inFileName,outFileName)
	puts "Processing #{inFileName} into #{outFileName}"
	k = 1
	j = 1
	inFile = buildFileNameArray(k, inFileName, 7)

	while(inFile.size > 1)
		print "."
		listOfFilesToProcess = "" 
		inFile.size.times do |i|
			listOfFilesToProcess += " #{inFile[i]}"
		end
		`convert #{listOfFilesToProcess} -evaluate-sequence mean #{outFileName}.#{j}.jpg`
	
		k += 10
		j += 1
		inFile = buildFileNameArray(k,inFileName,7)
	end
	puts "Done. Created #{j} files."
	return j
end

def runFirstPassForSequencesBetween(seqStart, seqEnd)

	k = 1

	((seqEnd +1) - seqStart).times do |loopCount|

		i = seqStart + loopCount
		j = 1
	
		inFile = "image.#{i}.#{j}.jpg"
		nextInFile = "image.#{i}.#{j+1}.jpg"
	
		puts "processing section '#{i}'"

		while(Pathname(inFile).exist? && Pathname(nextInFile).exist?)
			print "." 
			`convert #{inFile} #{nextInFile} -evaluate-sequence mean pass1.#{k}.jpg`
		
			j += 2
			k += 1
			inFile = "image.#{i}.#{j}.jpg"
			nextInFile = "image.#{i}.#{j+1}.jpg"
		end
		puts "done"
	end
end

def runFirstPassForAllImages
	contents = Dir.entries('.').sort
	i = 0
	filesToProcess = Array.new

	puts "Looking up Images."
	contents.each do |item|
		if item.include?('.jpg')
			itemArray = item.split('.')
			filesToProcess[i] = {}
			filesToProcess[i]['file'] = item
			filesToProcess[i]['sequence'] = itemArray[1].to_i
			filesToProcess[i]['number'] = itemArray[2].to_i
			
			i += 1
		end
	end
	puts "Sorting..."

	 	
	filesToProcess = filesToProcess.sort_by{|k| [k['sequence'],k['number']] }
	filesCount = filesToProcess.size	

	puts "Starting first pass processing (#{filesCount})..."	

	previous = 999
	k = 0
	
	filesCount.times do |i|
		if(i == previous)
			next
		end
		
		if(i+1 == filesCount)
			print 'unmatched final file.'
			next
		end		

		fileOne = filesToProcess[i]['file']
		fileTwo = filesToProcess[i+1]['file']
	
		print "."
		command = "convert #{fileOne} #{fileTwo} -evaluate-sequence mean pass1.#{k}.jpg"

		#puts command
		`#{command}`
		
		previous = i + 1
		k += 1		
	end


end


seqStart = 33 
seqEnd = 37

runFirstPassForAllImages


passCount = 1
lastPassName = "pass#{passCount}" 
thisPassName = "pass#{passCount+1}"

while( compositeBatchesOfSeven(lastPassName,thisPassName) >= 2)
	passCount += 1
	lastPassName = thisPassName
	thisPassName = "pass#{passCount+1}"
end

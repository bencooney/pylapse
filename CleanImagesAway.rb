countOfJpegs = Dir[File.join('.','*.jpg')].count
timeStamp = Time.now.strftime '%Y.%m.%d.%H.%M.%S'

if(countOfJpegs > 0)
	`mkdir images#{timeStamp}`
	`mv *.jpg images#{timeStamp}/.`
end
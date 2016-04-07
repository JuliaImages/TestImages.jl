using Images
f = open("open.txt")

content = readstring(f)

f = readdir("images/")

for i in f
	println("Processing "*i)
	img = load("images/"*i)
	fname, ext =splitext(i)
	file=""
	if length(size(img))==2
		file=fname*".png"
		if !isfile("webimages/"*fname*".png")
			save("webimages/"*fname*".png", img)
		end
	else
		file="cannot_be_displayed.png"
	end
	content *= "\""*fname*"\" : "*"{floc:\""*file*"\" ,col:\""*img.properties["colorspace"]*"\", size : \""*string(size(img))*"\", ftype : \""*uppercase(ext[2:end])*"\"},\n"
end

f = open("close.txt")

content *= readstring(f)

close(f)
outfile = open("displayimages.js", "w")
write(outfile,content)
close(outfile)
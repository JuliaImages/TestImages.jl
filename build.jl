using Images
f = open("open.txt")

content = readstring(f)

f = readdir("images/")

if isdir("thumbnails")
	rm("thumbnails/", recursive=true)
end

mkdir("thumbnails")
cp("cannot_be_displayed.png","thumbnails/cannot_be_displayed.png")

HEIGHT = 200

for i in f
	println("Processing "*i)
	img = load(joinpath("images/",i))
	fname, ext =splitext(i)
	file=""
	if length(size(img))==2
		file=fname*".png"
		if !isfile(joinpath("thumbnails/",file))
			img_size = size(img)
			resized_image = Images.imresize(img, (Int(ceil(img_size[1]*HEIGHT/img_size[2])), HEIGHT))
			save(joinpath("thumbnails/",file), resized_image)
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
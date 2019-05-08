function getImageHTML(image,f){

	var elem="<td class=\"text-center\">"

	elem += "<a href=\"images/" + image["file_location"] +"\"><img src=\"thumbnails/" + image["file_location"] + "\"class=\"table_image\"></a>"
	if ("name" in image) {
		elem += "<a href=\"images/" + image["file_location"] + "\">" + image["name"] + "</a><br>"
		elem +=" <span class=\"filename\"><code>"+f+"</code><br>"
	} else { // old style just link file
		elem += "<a href=\"images/"+image["file_location"]+"\">"+f+"</a><br>"
	}
	elem += "<dl>"
	elem += "<dt>Color</dt><dd>"+image["colorspace"]+"</dd>"
	elem += "<dt>Type</dt><dd>"+image["filetype"]+"</dd>"
	elem += "<dt>Size</dt><dd>"+image["size"]+"</dd>"
	elem += "</dl>"
	if ("url" in image) {
		elem += "<span class=\"meta_info\"><a href=\""+image["url"]+"\">source</a></span>"
	}
	if ("author" in image) {
		elem += "<span class=\"meta_info\">" + image["author"]+"</span>"
  }
	elem+="</td>"

	return elem;
}

$('document').ready(function(){

	var images = {"autumn_leaves" : {name:"Autum Leaves", url:"http://www.imagemagick.org/Usage/images/autumn_leaves.png", file_location:"autumn_leaves.png", colorspace:"RGB", size : "(105, 140)", filetype : "PNG"},
"blobs" : {file_location:"blobs.png", colorspace:"RGB4", size : "(254, 256)", filetype : "GIF"},
"cameraman" : {file_location:"cameraman.png", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"earth_apollo17" : {url:"http://upload.wikimedia.org/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg", file_location:"earth_apollo17.png", colorspace:"RGB4", size : "(3002, 3000)", filetype : "JPG"},
"fabio_color_256" : {file_location:"fabio_color_256.png", colorspace:"RGB4", size : "(256, 256)", filetype : "PNG"},
"fabio_color_512" : {file_location:"fabio_color_512.png", colorspace:"RGB4", size : "(512, 512)", filetype : "PNG"},
"fabio_gray_256" : {file_location:"fabio_gray_256.png", colorspace:"Gray", size : "(256, 256)", filetype : "PNG"},
"fabio_gray_512" : {file_location:"fabio_gray_512.png", colorspace:"Gray", size : "(512, 512)", filetype : "PNG"},
"hela-cells" : {file_location:"hela-cells.png", colorspace:"RGB", size : "(512, 672)", filetype : "TIF"},
"house" : {file_location:"house.png", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"jetplane" : {file_location:"jetplane.png", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"lake_color" : {name:"Sailboat on lake", url:"http://sipi.usc.edu/database/database.php?volume=misc&image=12#top", file_location:"lake_color.png", colorspace:"RGB", size : "(512, 512)", filetype : "TIF"},
"lake_gray" : {file_location:"lake_gray.png", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"lena_color_256" : {file_location:"lena_color_256.png", colorspace:"RGB", size : "(256, 256)", filetype : "TIF"},
"lena_color_512" : {file_location:"lena_color_512.png", colorspace:"RGB", size : "(512, 512)", filetype : "TIF"},
"lena_gray_16bit" : {file_location:"lena_gray_16bit.png", colorspace:"Gray", size : "(256, 256)", filetype : "PNG"},
"lena_gray_256" : {file_location:"lena_gray_256.png", colorspace:"Gray", size : "(256, 256)", filetype : "TIF"},
"lena_gray_512" : {url:"http://www.ece.rice.edu/~wakin/images/lenaTest3.jpg", file_location:"lena_gray_512.png", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"lighthouse" : {url:"http://r0k.us/graphics/kodak/kodak/kodim21.png", file_location:"lighthouse.png", colorspace:"RGB4", size : "(512, 768)", filetype : "PNG"},
"livingroom" : {file_location:"livingroom.png", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"m51" : {file_location:"m51.png", colorspace:"Gray", size : "(510, 320)", filetype : "TIF"},
"mandril_color" : {url:"http://sipi.usc.edu/database/database.php?volume=misc&image=10#top", file_location:"mandril_color.png", colorspace:"RGB", size : "(512, 512)", filetype : "TIF"},
"mandril_gray" : {file_location:"mandril_gray.png", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"mandrill" : {file_location:"mandrill.png", colorspace:"RGB", size : "(512, 512)", filetype : "TIFF"},
"moonsurface" : {file_location:"moonsurface.png", colorspace:"Gray", size : "(256, 256)", filetype : "TIFF"},
"mountainstream" : {url:"http://r0k.us/graphics/kodak/kodak/kodim13.png", file_location:"mountainstream.png", colorspace:"RGB4", size : "(512, 768)", filetype : "PNG"},
"mri-stack" : {file_location:"cannot_be_displayed.png", colorspace:"Gray", size : "(226, 186, 27)", filetype : "TIF"},
"multi-channel-time-series.ome" : {file_location:"cannot_be_displayed.png", colorspace:"Gray", size : "(167, 439, 3, 7)", filetype : "TIF"},
"peppers_color" : {name:"Peppers (color)", url:"http://sipi.usc.edu/database/database.php?volume=misc&image=13#top", file_location:"peppers_color.png", colorspace:"RGB", size : "(512, 512)", filetype : "TIF"},
"peppers_gray" : {file_location:"peppers_gray.png", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"pirate" : {url:"http://sipi.usc.edu/database/database.php?volume=misc&image=23#top", file_location:"pirate.png", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"toucan" : {file_location:"toucan.png", colorspace:"RGB", size : "(150, 162)", filetype : "PNG"},
"walkbridge" : {url:"http://sipi.usc.edu/database/database.php?volume=misc&image=22#top", file_location:"walkbridge.png", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"woman_blonde" : {file_location:"woman_blonde.png", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"woman_darkhair" : {file_location:"woman_darkhair.png", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
}

	var create_new_row=0;
	imagesHTML="<tr>"
	for(var i in images)
	{
		elem="";
		if(create_new_row%3==0 && create_new_row!=0){
			elem += "</tr><tr>";
		}
		elem += getImageHTML(images[i], i);
		imagesHTML+= elem
		create_new_row++;
	}
	imagesHTML+="</tr>"
	$("#table-body").append(imagesHTML);

});
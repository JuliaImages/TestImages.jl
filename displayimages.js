function getImageHTML(image,f){

	var elem="<td class=\"text-center\">"

	elem += "<a href=\"images/" + image["file"] +"\"><img src=\"thumbnails/" + image["thumbnail"] + "\"class=\"table_image\"></a>"
	if ("name" in image) {
		elem += "<a href=\"images/" + image["file"] + "\">" + image["name"] + "</a><br>"
		elem +=" <span class=\"filename\"><code>"+f+"</code><br>"
	} else { // old style just link file
		elem += "<a href=\"images/"+image["file"]+"\">"+f+"</a><br>"
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

	var images = {"autumn_leaves" : {name:"Autum Leaves", url:"http://www.imagemagick.org/Usage/images/autumn_leaves.png", thumbnail:"autumn_leaves.png", file:"autumn_leaves.png", colorspace:"RGB", size : "(105, 140)", filetype : "PNG"},
"blobs" : {thumbnail:"blobs.png", file:"blobs.gif", colorspace:"RGB4", size : "(254, 256)", filetype : "GIF"},
"cameraman" : {thumbnail:"cameraman.png", file:"cameraman.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"earth_apollo17" : {url:"http://upload.wikimedia.org/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg", thumbnail:"earth_apollo17.png", file:"earth_apollo17.jpg", colorspace:"RGB4", size : "(3002, 3000)", filetype : "JPG"},
"fabio_color_256" : {thumbnail:"fabio_color_256.png", file:"fabio_color_256.png", colorspace:"RGB4", size : "(256, 256)", filetype : "PNG"},
"fabio_color_512" : {thumbnail:"fabio_color_512.png", file:"fabio_color_512.png", colorspace:"RGB4", size : "(512, 512)", filetype : "PNG"},
"fabio_gray_256" : {thumbnail:"fabio_gray_256.png", file:"fabio_gray_256.png", colorspace:"Gray", size : "(256, 256)", filetype : "PNG"},
"fabio_gray_512" : {thumbnail:"fabio_gray_512.png", file:"fabio_gray_512.png", colorspace:"Gray", size : "(512, 512)", filetype : "PNG"},
"hela-cells" : {thumbnail:"hela-cells.png", file:"hela-cells.tif", colorspace:"RGB", size : "(512, 672)", filetype : "TIF"},
"house" : {thumbnail:"house.png", file:"house.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"jetplane" : {thumbnail:"jetplane.png", file:"jetplane.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"lake_color" : {name:"Sailboat on lake", url:"http://sipi.usc.edu/database/database.php?volume=misc&image=12#top", thumbnail:"lake_color.png", file:"lake_color.tif", colorspace:"RGB", size : "(512, 512)", filetype : "TIF"},
"lake_gray" : {thumbnail:"lake_gray.png", file:"lake_gray.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"lena_color_256" : {thumbnail:"lena_color_256.png", file:"lena_color_256.tif", colorspace:"RGB", size : "(256, 256)", filetype : "TIF"},
"lena_color_512" : {thumbnail:"lena_color_512.png", file:"lena_color_512.tif", colorspace:"RGB", size : "(512, 512)", filetype : "TIF"},
"lena_gray_16bit" : {thumbnail:"lena_gray_16bit.png", file:"lena_gray_16bit.png", colorspace:"Gray", size : "(256, 256)", filetype : "PNG"},
"lena_gray_256" : {thumbnail:"lena_gray_256.png", file:"lena_gray_256.tif", colorspace:"Gray", size : "(256, 256)", filetype : "TIF"},
"lena_gray_512" : {url:"http://www.ece.rice.edu/~wakin/images/lenaTest3.jpg", thumbnail:"lena_gray_512.png", file:"lena_gray_512.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"lighthouse" : {url:"http://r0k.us/graphics/kodak/kodak/kodim21.png", thumbnail:"lighthouse.png", file:"lighthouse.png", colorspace:"RGB4", size : "(512, 768)", filetype : "PNG"},
"livingroom" : {thumbnail:"livingroom.png", file:"livingroom.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"m51" : {thumbnail:"m51.png", file:"m51.tif", colorspace:"Gray", size : "(510, 320)", filetype : "TIF"},
"mandril_color" : {url:"http://sipi.usc.edu/database/database.php?volume=misc&image=10#top", thumbnail:"mandril_color.png", file:"mandril_color.tif", colorspace:"RGB", size : "(512, 512)", filetype : "TIF"},
"mandril_gray" : {thumbnail:"mandril_gray.png", file:"mandril_gray.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"mandrill" : {thumbnail:"mandrill.png", file:"mandrill.tiff", colorspace:"RGB", size : "(512, 512)", filetype : "TIFF"},
"moonsurface" : {thumbnail:"moonsurface.png", file:"moonsurface.tiff", colorspace:"Gray", size : "(256, 256)", filetype : "TIFF"},
"mountainstream" : {url:"http://r0k.us/graphics/kodak/kodak/kodim13.png", thumbnail:"mountainstream.png", file:"mountainstream.png", colorspace:"RGB4", size : "(512, 768)", filetype : "PNG"},
"mri-stack" : {thumbnail:"cannot_be_displayed.png", file:"mri-stack.tif", colorspace:"Gray", size : "(226, 186, 27)", filetype : "TIF"},
"multi-channel-time-series.ome" : {thumbnail:"cannot_be_displayed.png", file:"multi-channel-time-series.ome.tif", colorspace:"Gray", size : "(167, 439, 3, 7)", filetype : "TIF"},
"peppers_color" : {name:"Peppers (color)", url:"http://sipi.usc.edu/database/database.php?volume=misc&image=13#top", thumbnail:"peppers_color.png", file:"peppers_color.tif", colorspace:"RGB", size : "(512, 512)", filetype : "TIF"},
"peppers_gray" : {thumbnail:"peppers_gray.png", file:"peppers_gray.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"pirate" : {url:"http://sipi.usc.edu/database/database.php?volume=misc&image=23#top", thumbnail:"pirate.png", file:"pirate.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"toucan" : {thumbnail:"toucan.png", file:"toucan.png", colorspace:"RGB", size : "(150, 162)", filetype : "PNG"},
"walkbridge" : {url:"http://sipi.usc.edu/database/database.php?volume=misc&image=22#top", thumbnail:"walkbridge.png", file:"walkbridge.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"woman_blonde" : {thumbnail:"woman_blonde.png", file:"woman_blonde.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"woman_darkhair" : {thumbnail:"woman_darkhair.png", file:"woman_darkhair.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
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
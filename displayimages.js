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

	var images = {"airplaneF16" : {name:"Airplane (F-16)", url:"http://sipi.usc.edu/database/download.php?vol=misc&img=4.2.05", author:"USC-SIPI Image Database", thumbnail:"airplaneF16.png", file:"airplaneF16.tiff", colorspace:"RGB", size : "(512, 512)", filetype : "TIFF"},
"autumn_leaves" : {name:"Autum Leaves", url:"http://www.imagemagick.org/Usage/images/autumn_leaves.png", thumbnail:"autumn_leaves.png", file:"autumn_leaves.png", colorspace:"RGB", size : "(105, 140)", filetype : "PNG"},
"barbara_color" : {thumbnail:"barbara_color.png", file:"barbara_color.png", colorspace:"RGB", size : "(576, 720)", filetype : "PNG"},
"barbara_gray_512" : {thumbnail:"barbara_gray_512.png", file:"barbara_gray_512.bmp", colorspace:"RGB", size : "(512, 512)", filetype : "BMP"},
"blobs" : {thumbnail:"blobs.png", file:"blobs.gif", colorspace:"RGB", size : "(254, 256)", filetype : "GIF"},
"cameraman" : {thumbnail:"cameraman.png", file:"cameraman.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"chelsea" : {name:"Chelsea", url:"https://github.com/scikit-image/scikit-image/blob/d254263605c6c173c563258d51f44e65782d4365/skimage/data/chelsea.png", author:"Stefan van der Walt", thumbnail:"chelsea.png", file:"chelsea.png", colorspace:"RGB", size : "(300, 451)", filetype : "PNG"},
"coffee" : {name:"coffee", url:"https://github.com/scikit-image/scikit-image/blob/d254263605c6c173c563258d51f44e65782d4365/skimage/data/coffee.png", author:"Rachel Michetti", thumbnail:"coffee.png", file:"coffee.png", colorspace:"RGB", size : "(400, 600)", filetype : "PNG"},
"earth_apollo17" : {url:"http://upload.wikimedia.org/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg", thumbnail:"earth_apollo17.png", file:"earth_apollo17.jpg", colorspace:"RGB", size : "(3002, 3000)", filetype : "JPG"},
"fabio_color_256" : {thumbnail:"fabio_color_256.png", file:"fabio_color_256.png", colorspace:"RGB", size : "(256, 256)", filetype : "PNG"},
"fabio_color_512" : {thumbnail:"fabio_color_512.png", file:"fabio_color_512.png", colorspace:"RGB", size : "(512, 512)", filetype : "PNG"},
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
"lighthouse" : {url:"http://r0k.us/graphics/kodak/kodak/kodim21.png", thumbnail:"lighthouse.png", file:"lighthouse.png", colorspace:"RGB", size : "(512, 768)", filetype : "PNG"},
"livingroom" : {thumbnail:"livingroom.png", file:"livingroom.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"m51" : {thumbnail:"m51.png", file:"m51.tif", colorspace:"Gray", size : "(510, 320)", filetype : "TIF"},
"mandril_color" : {url:"http://sipi.usc.edu/database/database.php?volume=misc&image=10#top", thumbnail:"mandril_color.png", file:"mandril_color.tif", colorspace:"RGB", size : "(512, 512)", filetype : "TIF"},
"mandril_gray" : {thumbnail:"mandril_gray.png", file:"mandril_gray.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"mandrill" : {thumbnail:"mandrill.png", file:"mandrill.tiff", colorspace:"RGB", size : "(512, 512)", filetype : "TIFF"},
"monarch_color" : {thumbnail:"monarch_color.png", file:"monarch_color.png", colorspace:"RGB", size : "(512, 768)", filetype : "PNG"},
"monarch_color_256" : {thumbnail:"monarch_color_256.png", file:"monarch_color_256.png", colorspace:"RGB", size : "(256, 256)", filetype : "PNG"},
"moonsurface" : {thumbnail:"moonsurface.png", file:"moonsurface.tiff", colorspace:"Gray", size : "(256, 256)", filetype : "TIFF"},
"morphology_test_512" : {url:"https://gist.github.com/ashwani-rathee/a835ea20bb522d35e7441978686a1951", author:"Ashwani Rathee", thumbnail:"morphology_test_512.png", file:"morphology_test_512.tiff", colorspace:"RGB", size : "(512, 512)", filetype : "TIFF"},
"mountainstream" : {url:"http://r0k.us/graphics/kodak/kodak/kodim13.png", thumbnail:"mountainstream.png", file:"mountainstream.png", colorspace:"RGB", size : "(512, 768)", filetype : "PNG"},
"mri-stack" : {thumbnail:"cannot_be_displayed.png", file:"mri-stack.tif", colorspace:"Gray", size : "(226, 186, 27)", filetype : "TIF"},
"multi-channel-time-series.ome" : {thumbnail:"cannot_be_displayed.png", file:"multi-channel-time-series.ome.tif", colorspace:"Gray", size : "(167, 439, 3, 7)", filetype : "TIF"},
"peppers_color" : {name:"Peppers (color)", url:"http://sipi.usc.edu/database/database.php?volume=misc&image=13#top", thumbnail:"peppers_color.png", file:"peppers_color.tif", colorspace:"RGB", size : "(512, 512)", filetype : "TIF"},
"peppers_gray" : {thumbnail:"peppers_gray.png", file:"peppers_gray.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"pirate" : {url:"http://sipi.usc.edu/database/database.php?volume=misc&image=23#top", thumbnail:"pirate.png", file:"pirate.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"resolution_test_1920" : {name:"Resolution test chart (1920 pixel)", url:"https://www.osapublishing.org/oe/abstract.cfm?uri=oe-21-2-2032", author:"Kai Wicker", thumbnail:"resolution_test_1920.png", file:"resolution_test_1920.tif", colorspace:"Gray", size : "(1920, 1920)", filetype : "TIF"},
"resolution_test_512" : {name:"Resolution test chart (512 pixel)", url:"https://www.osapublishing.org/oe/abstract.cfm?uri=oe-21-2-2032", author:"Kai Wicker", thumbnail:"resolution_test_512.png", file:"resolution_test_512.tif", colorspace:"Gray", size : "(512, 512)", filetype : "TIF"},
"simple_3d_ball" : {name:"A 3D test image of a ball with some extra structure (64pixel in each dimension)", author:"Rainer Heintzmann", thumbnail:"cannot_be_displayed.png", file:"simple_3d_ball.tif", colorspace:"Gray", size : "(64, 64, 64)", filetype : "TIF"},
"simple_3d_psf" : {name:"A simple 3D point spread function of a circular aperture (64pixel in each dimension)", author:"Rainer Heintzmann", thumbnail:"cannot_be_displayed.png", file:"simple_3d_psf.tif", colorspace:"Gray", size : "(64, 64, 64)", filetype : "TIF"},
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
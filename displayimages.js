function getImageHTML(image,f){

	var elem="<td class=\"text-center\">"

	elem += "<a href=\"images/" + image["file_location"] +"\"><img src=\"thumbnails/" + image["file_location"] + "\"class=\"table_image\"></a>"
	if ("name" in image) {
		elem += "<a href=\"images/" + image["file_location"] + "\">" + image["name"] + "</a><br>"
		elem +=" <span class=\"filename\">"+f+"<br>"
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

	var images = {"autumn_leaves" : {name:"Autumn Leaves", author: "A", url:"B",file_location:"autumn_leaves.png" ,colorspace:"sRGB", size : "(140,105)", filetype : "PNG"},
"blobs" : {file_location:"blobs.png" ,colorspace:"sRGB", size : "(256,254)", filetype : "GIF"},
"cameraman" : {file_location:"cameraman.png" ,colorspace:"Gray", size : "(512,512)", filetype : "TIF"},
"earth_apollo17" : {file_location:"earth_apollo17.png" ,colorspace:"sRGB", size : "(3000,3002)", filetype : "JPG"},
"fabio_color_256" : {file_location:"fabio_colorspaceor_256.png" ,colorspace:"sRGB", size : "(256,256)", filetype : "PNG"},
"fabio_color_512" : {file_location:"fabio_colorspaceor_512.png" ,colorspace:"sRGB", size : "(512,512)", filetype : "PNG"},
"fabio_gray_256" : {file_location:"fabio_gray_256.png" ,colorspace:"Gray", size : "(256,256)", filetype : "PNG"},
"fabio_gray_512" : {file_location:"fabio_gray_512.png" ,colorspace:"Gray", size : "(512,512)", filetype : "PNG"},
"hela-cells" : {file_location:"hela-cells.png" ,colorspace:"sRGB", size : "(672,512)", filetype : "TIF"},
"house" : {file_location:"house.png" ,colorspace:"Gray", size : "(512,512)", filetype : "TIF"},
"jetplane" : {file_location:"jetplane.png" ,colorspace:"Gray", size : "(512,512)", filetype : "TIF"},
"lake" : {file_location:"lake.png" ,colorspace:"Gray", size : "(512,512)", filetype : "TIF"},
"lena_colorspaceor_256" : {file_location:"lena_colorspaceor_256.png" ,colorspace:"sRGB", size : "(256,256)", filetype : "TIF"},
"lena_colorspaceor_512" : {file_location:"lena_colorspaceor_512.png" ,colorspace:"sRGB", size : "(512,512)", filetype : "TIF"},
"lena_gray_16bit" : {file_location:"lena_gray_16bit.png" ,colorspace:"Gray", size : "(256,256)", filetype : "PNG"},
"lena_gray_256" : {file_location:"lena_gray_256.png" ,colorspace:"Gray", size : "(256,256)", filetype : "TIF"},
"lena_gray_512" : {file_location:"lena_gray_512.png" ,colorspace:"Gray", size : "(512,512)", filetype : "TIF"},
"lighthouse" : {file_location:"lighthouse.png" ,colorspace:"sRGB", size : "(768,512)", filetype : "PNG"},
"livingroom" : {file_location:"livingroom.png" ,colorspace:"Gray", size : "(512,512)", filetype : "TIF"},
"m51" : {file_location:"m51.png" ,colorspace:"Gray", size : "(320,510)", filetype : "TIF"},
"mandril_colorspaceor" : {file_location:"mandril_colorspaceor.png" ,colorspace:"sRGB", size : "(512,512)", filetype : "TIF"},
"mandril_gray" : {file_location:"mandril_gray.png" ,colorspace:"Gray", size : "(512,512)", filetype : "TIF"},
"mandrill" : {file_location:"mandrill.png" ,colorspace:"sRGB", size : "(512,512)", filetype : "TIFF"},
"moonsurface" : {file_location:"moonsurface.png" ,colorspace:"Gray", size : "(256,256)", filetype : "TIFF"},
"mountainstream" : {file_location:"mountainstream.png" ,colorspace:"sRGB", size : "(768,512)", filetype : "PNG"},
"mri-stack" : {file_location:"cannot_be_displayed.png" ,colorspace:"Gray", size : "(186,226,27)", filetype : "TIF"},
"multi-channel-time-series.ome" : {file_location:"cannot_be_displayed.png" ,colorspace:"Gray", size : "(439,167,21)", filetype : "TIF"},
"peppers_colorspaceor" : {file_location:"peppers_colorspaceor.png" ,colorspace:"sRGB", size : "(512,512)", filetype : "TIF"},
"peppers_gray" : {file_location:"peppers_gray.png" ,colorspace:"Gray", size : "(512,512)", filetype : "TIF"},
"pirate" : {file_location:"pirate.png" ,colorspace:"Gray", size : "(512,512)", filetype : "TIF"},
"toucan" : {file_location:"toucan.png" ,colorspace:"RGB", size : "(162,150)", filetype : "PNG"},
"walkbridge" : {file_location:"walkbridge.png" ,colorspace:"Gray", size : "(512,512)", filetype : "TIF"},
"woman_blonde" : {file_location:"woman_blonde.png" ,colorspace:"Gray", size : "(512,512)", filetype : "TIF"},
"woman_darkhair" : {file_location:"woman_darkhair.png" ,colorspace:"Gray", size : "(512,512)", filetype : "TIF"},
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
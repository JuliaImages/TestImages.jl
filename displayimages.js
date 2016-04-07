function getImageHTML(image,f){

	var elem="<td class=\"text-center\">"

	elem += "<img src=\"webimages/"+image["floc"]+"\"class=\"table_image\">"
	elem += "<h5> Name : <a href=\"images/"+image["floc"]+"\">"+f+"</a></h5>"
	elem += "<h5> Colour : "+image["col"]+"</h5>"
	elem += "<h5> File Type : "+image["ftype"]+"</h5>"
	elem += "<h5> Size : "+image["size"]+"</h5>"
	elem+="</td>"

	return elem;
}


$('document').ready(function(){

	var images = {"autumn_leaves" : {floc:"autumn_leaves.png" ,col:"sRGB", size : "(140,105)", ftype : "PNG"},
"blobs" : {floc:"blobs.png" ,col:"sRGB", size : "(256,254)", ftype : "GIF"},
"cameraman" : {floc:"cameraman.png" ,col:"Gray", size : "(512,512)", ftype : "TIF"},
"earth_apollo17" : {floc:"earth_apollo17.png" ,col:"sRGB", size : "(3000,3002)", ftype : "JPG"},
"hela-cells" : {floc:"hela-cells.png" ,col:"sRGB", size : "(672,512)", ftype : "TIF"},
"house" : {floc:"house.png" ,col:"Gray", size : "(512,512)", ftype : "TIF"},
"jetplane" : {floc:"jetplane.png" ,col:"Gray", size : "(512,512)", ftype : "TIF"},
"lake" : {floc:"lake.png" ,col:"Gray", size : "(512,512)", ftype : "TIF"},
"lena_color_256" : {floc:"lena_color_256.png" ,col:"sRGB", size : "(256,256)", ftype : "TIF"},
"lena_color_512" : {floc:"lena_color_512.png" ,col:"sRGB", size : "(512,512)", ftype : "TIF"},
"lena_gray_16bit" : {floc:"lena_gray_16bit.png" ,col:"Gray", size : "(256,256)", ftype : "PNG"},
"lena_gray_256" : {floc:"lena_gray_256.png" ,col:"Gray", size : "(256,256)", ftype : "TIF"},
"lena_gray_512" : {floc:"lena_gray_512.png" ,col:"Gray", size : "(512,512)", ftype : "TIF"},
"lighthouse" : {floc:"lighthouse.png" ,col:"sRGB", size : "(768,512)", ftype : "PNG"},
"livingroom" : {floc:"livingroom.png" ,col:"Gray", size : "(512,512)", ftype : "TIF"},
"m51" : {floc:"m51.png" ,col:"Gray", size : "(320,510)", ftype : "TIF"},
"mandril_color" : {floc:"mandril_color.png" ,col:"sRGB", size : "(512,512)", ftype : "TIF"},
"mandril_gray" : {floc:"mandril_gray.png" ,col:"Gray", size : "(512,512)", ftype : "TIF"},
"mandrill" : {floc:"mandrill.png" ,col:"sRGB", size : "(512,512)", ftype : "TIFF"},
"moonsurface" : {floc:"moonsurface.png" ,col:"Gray", size : "(256,256)", ftype : "TIFF"},
"mountainstream" : {floc:"mountainstream.png" ,col:"sRGB", size : "(768,512)", ftype : "PNG"},
"mri-stack" : {floc:"cannot_be_displayed.png" ,col:"Gray", size : "(186,226,27)", ftype : "TIF"},
"multi-channel-time-series.ome" : {floc:"cannot_be_displayed.png" ,col:"Gray", size : "(439,167,21)", ftype : "TIF"},
"peppers_color" : {floc:"peppers_color.png" ,col:"sRGB", size : "(512,512)", ftype : "TIF"},
"peppers_gray" : {floc:"peppers_gray.png" ,col:"Gray", size : "(512,512)", ftype : "TIF"},
"pirate" : {floc:"pirate.png" ,col:"Gray", size : "(512,512)", ftype : "TIF"},
"toucan" : {floc:"toucan.png" ,col:"RGB", size : "(162,150)", ftype : "PNG"},
"walkbridge" : {floc:"walkbridge.png" ,col:"Gray", size : "(512,512)", ftype : "TIF"},
"woman_blonde" : {floc:"woman_blonde.png" ,col:"Gray", size : "(512,512)", ftype : "TIF"},
"woman_darkhair" : {floc:"woman_darkhair.png" ,col:"Gray", size : "(512,512)", ftype : "TIF"},
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
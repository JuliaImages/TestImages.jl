function getImageHTML(image,f){

	var elem="<td class=\"text-center\">"

	elem += "<img src=\"images/"+image["fname"]+"\"class=\"table_image\">"
	elem += "<h5> Name : <a href=\"images/"+image["fname"]+"\">"+f+"</a></h5>"
	elem += "<h5> Colour : "+image["col"]+"</h5>"
	elem += "<h5> File Type : "+image["ftype"]+"</h5>"
	elem += "<h5> Size : "+image["size"]+"</h5>"
	elem+="</td>"

	return elem;
}


$('document').ready(function(){

	var images = {
	autumn_leaves : {fname:"autumn_leaves.png", col:"sRGB", size : "140x105", ftype: "PNG"},
	blobs : {fname:"blobs.gif", col:"sRGB", size : "256x254", ftype: "GIF"},
	cameraman : {fname:"cameraman.tif", col:"Gray", size : "512x512", ftype:"TIFF"},
	earth_apollo17 : {fname:"earth_apollo17.jpg", col:"sRGB", size : "3000x3002", ftype:"JPG"},
	"hela-cells" : {fname:"hela-cells.tif", col:"sRGB", size : "672x512", ftype:"TIFF"},
	house : {fname:"house.tif", col:"Gray", size : "512x512", ftype:"TIFF"},
	jetplane : {fname:"jetplane.tif", col:"Gray", size : "512x512", ftype:"TIFF"},
	lake : {fname:"lake.tif", col:"Gray", size : "512x512", ftype:"TIFF"},
	lena_color_256 : {fname:"lena_color_256.tif", col:"sRGB", size : "256x256", ftype:"TIFF"},
	lena_color_512 : {fname:"lena_color_512.tif", col:"sRGB", size : "512x512", ftype:"TIFF"},
	lena_gray_16bit : {fname:"lena_gray_16bit.png", col:"Gray", size : "256x256", ftype: "PNG"},
	lena_gray_256 : {fname:"lena_gray_256.tif", col:"Gray", size : "256x256", ftype:"TIFF"},
	lena_gray_512 : {fname:"lena_gray_512.tif", col:"Gray", size : "512x512", ftype:"TIFF"},
	lighthouse : {fname:"lighthouse.png", col:"sRGB", size : "768x512", ftype: "PNG"},
	livingroom : {fname:"livingroom.tif", col:"Gray", size : "512x512", ftype:"TIFF"},
	m51 : {fname:"m51.tif", col:"Gray", size : "320x510", ftype:"TIFF"},
	mandril_color : {fname:"mandril_color.tif", col:"sRGB", size : "512x512", ftype:"TIFF"},
	mandril_gray : {fname:"mandril_gray.tif", col:"Gray", size : "512x512", ftype:"TIFF"},
	mandrill : {fname:"mandrill.tiff", col:"sRGB", size : "512x512", ftype:"TIFF"},
	moonsurface : {fname:"moonsurface.tiff", col:"Gray", size : "256x256", ftype:"TIFF"},
	mountainstream : {fname:"mountainstream.png", col:"sRGB", size : "768x512", ftype: "PNG"},
	"mri-stack" : {fname:"mri-stack.tif", col:"Gray", size : "186x226x27", ftype:"TIFF"},
	"multi-channel-time-series.ome" : {fname:"multi-channel-time-series.ome.tif", col:"Gray", size : "439x167x21", ftype:"TIFF"},
	peppers_color : {fname:"peppers_color.tif", col:"sRGB", size : "512x512", ftype:"TIFF"},
	peppers_gray : {fname:"peppers_gray.tif", col:"Gray", size : "512x512", ftype:"TIFF"},
	pirate : {fname:"pirate.tif", col:"Gray", size : "512x512", ftype:"TIFF"},
	toucan : {fname:"toucan.png", col:"RGB", size : "162x150", ftype: "PNG"},
	walkbridge : {fname:"walkbridge.tif", col:"Gray", size : "512x512", ftype:"TIFF"},
	woman_blonde : {fname:"woman_blonde.tif", col:"Gray", size : "512x512", ftype:"TIFF"},
	woman_darkhair : {fname:"woman_darkhair.tif", col:"Gray", size : "512x512", ftype:"TIFF"}
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

	// $("#table-body").append(get);
});
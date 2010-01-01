function ci_map_initialize() {
	var map_center = new google.maps.LatLng(37.4419, 0);
	var myOptions = {
		zoom: 2,
		center: map_center,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};
	map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

	//  TODO: entry_category is being passed as a global variable.  Isn't there a
	//         better way to do this?
	var json_url = "/map/json/" + entry_category;

	//  HACK: If the user is connecting from localhost (e.g. during development), then
	//         we allow a relative pathname.  Otherwise, we use an absolute pathname
	//         with a hostname so that the map can be embedded in other sites.
	if (location.hostname.search(/localhost/) == -1) {
		//  jQuery uses the 'callback=?' parameter to accept JSON from a remote site.
		//   For more details, see:
		//     http://docs.jquery.com/Ajax/jQuery.getJSON
		//  The Rails controller also needs to be modififed to support remote JSON
		//   queries using:
		//      render :layout => false, :json => [...], :callback => params[:callback]
		//  TODO: Switch from JSON to XML to avoid all the JSON related security issues
		json_url = "http://contactimprov.net" + json_url + "?callback=?";
	}

	$.getJSON(json_url,
		function(marker_info) {
			var markercount = 0;

			for (var coordinates in marker_info) {
				var lat_lng = coordinates.split('|');

				//  TODO: For some reason, marker_info[coordinates] is not treated as an Array
				//         unless the Prototype JavaScript framework has been loded.
				if (marker_info[coordinates].size() > 1) {
					ci_map_add_tabbed_infowindow(lat_lng[0], lat_lng[1], marker_info[coordinates], markercount++);
				}
				else {
					ci_map_add_infowindow(lat_lng[0], lat_lng[1], marker_info[coordinates][0], markercount++);
				}
			}
		}
	);
}

function ci_map_add_infowindow(lat, lng, marker_info, markercount) {
	var latlng = new google.maps.LatLng(lat, lng);
	markers[markercount] = new google.maps.Marker({
		position: latlng,
		map: map,
		title: marker_info.mouseover_text,
		icon: ci_map_image_url_for_entry_class(marker_info.entry_class)
	});
	var infowindow = new google.maps.InfoWindow({
		content: marker_info.infowindow_html
	});
	google.maps.event.addListener(markers[markercount], 'click', 
		function() { infowindow.open(map, markers[markercount]); } );
}

function ci_map_add_tabbed_infowindow(lat, lng, marker_info_array, markercount) {
	var mouseover_text_array = [];
	for (var i = 0; i < marker_info_array.size(); i++) {
		mouseover_text_array.push(marker_info_array[i].mouseover_text);
	}
	var mouseover_text = mouseover_text_array.join(",\n");

	var latlng = new google.maps.LatLng(lat, lng);
	markers[markercount] = new google.maps.Marker({
		position: latlng,
		map: map,
		title: mouseover_text,
		icon: 'http://www.google.com/mapfiles/marker_purple.png'
	});
	var infowindow = new google.maps.InfoWindow({
		content: ci_map_get_tabbed_infowindow_html(marker_info_array, markercount)
	});
	google.maps.event.addListener(markers[markercount], 'click', 
		function() { 
			infowindow.open(map, markers[markercount]); 
			$("#tabs_" + markercount).tabs();
		} 
	);
}

function ci_map_image_url_for_entry_class(entry_class) {
	switch(entry_class) {
		case 'Event':
			return 'http://www.google.com/mapfiles/marker_greenE.png';
		case 'Jam':
			return 'http://www.google.com/mapfiles/marker_yellowJ.png';
		case 'Organization':
			return 'http://www.google.com/mapfiles/marker_brownO.png';
		case 'Person':
			return 'http://www.google.com/mapfiles/marker_orangeP.png';
	}
}

function ci_map_get_tabbed_infowindow_html(marker_info_array, markercount) {
	var s;
	
	s = '<div id="tabs_' + markercount + '" style="font-size: 11px; width: 320px; height: 120px;">' +
	    '<ul>';
	for (var i = 0; i < marker_info_array.length; i++) {
        s += '<li><a href="#fragment-' + i + '_' + markercount + '"><span>' + 
			marker_info_array[i]['entry_class'] + '</span></a></li>';
	}
	s += '</ul>';
	for (var i = 0; i < marker_info_array.length; i++) {
		s += '<div id="fragment-' + i + '_' + markercount + '">' +
		    marker_info_array[i]['infowindow_html'] +
		    '</div>';
	}
    s += '</div>';

	return s;
}

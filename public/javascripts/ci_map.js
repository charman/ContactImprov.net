function ci_map_initialize(feed_url) {
  $('#map_canvas').gmap({ 'center': new google.maps.LatLng(37.4419, 0), 'zoom': 2, 'streetViewControl': false, 'mapTypeId': google.maps.MapTypeId.TERRAIN, 'callback': function (map) {
    $.get(feed_url, function(xml_data) {
    	var entries_by_lat_comma_lng = new Array();

      //  Parse XML feed, store entry info in global array 'entries_by_lat_comma_lng'
      $('listings', xml_data).children('listing').each(function() {
        var latitude  = $('latitude', this).text();
        var longitude = $('longitude', this).text();
        var lat_comma_lng = latitude + ',' + longitude;

        if (!(lat_comma_lng in entries_by_lat_comma_lng)) {
          entries_by_lat_comma_lng[lat_comma_lng] = new Array();
        } 
        entries_by_lat_comma_lng[lat_comma_lng].push({
          'title': $('title', this).text(),
          'description': $('description', this).text(),
          'url': $('url', this).text(),
          'address': $('address', this).text(),
          'listing_type': $('listing_type', this).text()
          //  TODO: Add more fields here
        });
      });

      //  Add a Marker for each GPS coordinate
      for (var lat_comma_lng in entries_by_lat_comma_lng) {
        var latlng = lat_comma_lng.split(',');
        var total_entries = entries_by_lat_comma_lng[lat_comma_lng].length;
        
        $('#map_canvas').gmap('addMarker', {
          'position': new google.maps.LatLng(latlng[0], latlng[1]),
          'icon':new google.maps.MarkerImage(marker_image_url_for_entries(entries_by_lat_comma_lng[lat_comma_lng])),

          //  Attach the array of entries for the GPS coordinate to the Marker object
          'contactimprov_entries': entries_by_lat_comma_lng[lat_comma_lng]
        }).click(function() {
          var marker = $(this).get(0);
          var entries = marker.contactimprov_entries;
          
          if (entries.length > 1) {
            map.panTo(marker.getPosition());
            show_dialog(entries);
          }
          else {
            var infowindow = new google.maps.InfoWindow({
              content: html_for_entry(entries[0])
            }).open(map, marker);
          }
        });
      }

    }, 'xml');
  }});

  function html_for_entry(entry) {
    return '<div>' + 
        '<span style="font-size: 1.2em; font-weight: bold;">' + entry.title + '</span><br />' +
        '<span><a href="' + entry.url + '">more info »</a></span><br />' +
        '<span>' + entry.address + '</span><br />' +
      '</div>';
  }

  function show_dialog(entries) {
    if (entries.length > 1) {
      var h = '';
      for (i in entries) {
        h += '<h3 style="font-weight: bold; font-size: 13px;"><a href="' + entries[i].url + '">' + entries[i].title + '</a></h3>' + 
          '<div style="font-size: 13px;">' + 
            '<span><a href="' + entries[i].url + '">more info »</a></span><br />' +
          '</div>';
      }
      $('<div></div>')
        .html(h)
        .dialog({
          'title': entries[0].address,
          'width': 500
        })
        .accordion({
          'collapsible': true
        });
    }
    else {
      $('<div></div>')
        .html('<div>' + entries[0].description + '</div>')
        .dialog({
          'title': '<a href="' + entries[0].url + '">' + entries[0].title + '</a>',
          'width': 500,
        });
    }
  }

  function marker_image_url_for_entries(entries) {
    if (entries.length > 1) {
      return marker_image_url_for_n_entries(entries.length);
    }
    else {
      return marker_image_url_for_listing_type(entries[0].listing_type);
    }
  }

  function marker_image_url_for_listing_type(lt) {
    if (lt == 'event') {
      return 'http://www.google.com/mapfiles/marker_greenE.png';
    }
    else if (lt == 'jam') {
      return 'http://www.google.com/mapfiles/marker_yellowJ.png';
    }
    else if (lt == 'organization') {
      return 'http://www.google.com/mapfiles/marker_brownO.png';
    }
    else if (lt == 'person') {
      return 'http://www.google.com/mapfiles/marker_orangeP.png';
    }
  }

  function marker_image_url_for_n_entries(n) {
    //  The google-maps-icons project only has icons for numbers up to 20 for most of the
    //  colored numeric icon sets.  For the full list, see:
    //    http://code.google.com/p/google-maps-icons/wiki/NumericIcons
    if (n >= 20) {
      n = 20;
    }

    var zero_padded_n = (n < 10 ? '0' : '') + n;

    return 'http://google-maps-icons.googlecode.com/files/purple' + zero_padded_n + '.png';
  }
}

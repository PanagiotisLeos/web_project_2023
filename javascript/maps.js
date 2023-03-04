var mymap = L.map('mapid')
var osmUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
var osmAttrib = 'Map data � <a href="https://openstreetmap.org">OpenStreetMap</a> contributors';

var osm = new L.TileLayer(osmUrl, { attribution: osmAttrib });

mymap.addLayer(osm);

mymap.setView([38.246242, 21.7350847], 16);



let markersLayer = L.layerGroup(); //layer contain searched elements

mymap.addLayer(markersLayer);



var data = [
    { "loc": [41.575330, 13.102411], "title": "aquamarine" },
    { "loc": [41.575730, 13.002411], "title": "black" },
    { "loc": [41.807149, 13.162994], "title": "blue" },
    { "loc": [41.507149, 13.172994], "title": "chocolate" },
    { "loc": [41.847149, 14.132994], "title": "coral" },
];

markersLayer.addTo(mymap);
let controlSearch = new L.Control.Search({
    position: "topright",
    layer: markersLayer,
    propertyName: "title",
    initial: false,
    zoom: 20,
    marker: false,
    textPlaceholder: "Search for supermarkets"
});

mymap.addControl(controlSearch);


for (i in data) {
    var title = data[i].title,	//value searched
        loc = data[i].loc,		//position found
        marker = new L.Marker(new L.latLng(loc), { title: title });//se property searched
    marker.bindPopup('title: ' + title);
    markersLayer.addLayer(marker);
}

var featuresLayer = new L.GeoJSON(data, {
    onEachFeature: function (feature, marker) {
        marker.bindPopup("<h4>" + feature.properties.name + "</h4>");
    }
});
featuresLayer.addTo(mymap);


            
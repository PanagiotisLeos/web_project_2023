var map = L.map('map').setView([38.246242, 21.7350847], 16);

var simulatedUserLocation = L.latLng(38.246242, 21.7350847);

var greenIcon = new L.Icon({
  iconUrl:
    "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-green.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png",
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41],
});

var orangeIcon = new L.Icon({
  iconUrl:
    "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-orange.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png",
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41],
});


L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
  maxZoom: 19,
  attribution: '© OpenStreetMap'
}).addTo(map);

var layerGroup = L.layerGroup();

layerGroup.addTo(map);

var markersLayer = new L.layerGroup();	
var offersMarkersLayer = new L.layerGroup();


offersMarkersLayer.addTo(map);

var controlSearch = new L.Control.Search({
  position:'topright',		
  layer: markersLayer,
  initial: false,
  zoom: 12,
  marker: false
});

controlSearch.on("search:locationfound", function (e) {
  if (e.layer._popup) e.layer.openPopup();
});

map.addControl( controlSearch );

var categoryFilter = L.control({position: 'topleft'});
        categoryFilter.onAdd = function (map) {
            var div = L.DomUtil.create('div', 'categories');
            div.innerHTML = '<select id="categoryFilter"></select>'; // Empty select element
            return div;
};
categoryFilter.addTo(map);

function populateCategoryDropdown(categories) {
  var selectElement = document.getElementById('categoryFilter');

  // Add an "All Categories" option as the default
  var allOption = document.createElement('option');
  allOption.value = 'all';
  allOption.textContent = 'All Categories';
  selectElement.appendChild(allOption);

  // Loop through categories and add options to the select element
  categories.forEach(function(category) {
    var option = document.createElement('option');
    option.textContent = category.name;
    selectElement.appendChild(option);
  });
}


// Ckeckbox for showing stores without offers
var showNoOfferStores = L.control({position: 'topleft'});
        showNoOfferStores.onAdd = function (map) {
            var div = L.DomUtil.create('div', 'showNoOfferStores');
            div.innerHTML = '<form><input id="showNoOfferStores" type="checkbox"/>Show stores without offers</form>';
            return div;
};
showNoOfferStores.addTo(map);

map.locate({ setView: true, maxZoom: 13 });
lc = L.control.locate({ initialZoomLevel: 14, flyTo: true }).addTo(mymap);






 

function searchByAjax(){
  $.ajax({
    url: '../php/stores.php', // Your PHP script to retrieve data
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      var stores = {};
        // Loop through the fetched data and create markers
        data.forEach(function(markerData) {
          var title=markerData.store_name;
          var storeLocation = L.latLng(markerData.latitude, markerData.longitude);
          var distance = simulatedUserLocation.distanceTo(storeLocation);
          var storeId = markerData.store_id;
          
          
          
            stores[storeId] = {
              store_name: markerData.store_name,
              latitude: markerData.latitude,
              longitude: markerData.longitude,
              offers: [],
            };
          
        
          // Check if the current markerData has an offer
          if (markerData.product_name && markerData.price) {
            console.log(`Adding offer to store ${storeId}`);

            // Push the offer into the 'offers' array of the corresponding store
            stores[storeId].offers.push({
              product_name: markerData.product_name,
              price: markerData.price,
            });
          }
        
      for (var storeId in stores) {
        var storeData = stores[storeId];

        if(storeData.offers.length > 0) {
        var OfferspopupContent = `
          <div class='popup'>
            <h3>${title}</h3>
            <p style='font-weight:bold'>Offers</p>
            ${storeData.offers.map(offer => `
              <p>Product: ${offer.product_name}</p>
              <p>Price: ${offer.price}</p>
            `).join('')}
          </div>`;

          var marker = L.marker(
            [storeData.latitude, storeData.longitude],{title: title, icon: orangeIcon , category:markerData.category_name})
            marker.bindPopup(OfferspopupContent)
            offersMarkersLayer.addLayer(marker);
      }
      else{
        var popupContent =  `
          <div class='popup'>
              <h3>${title}</h3>
              ${distance < 500 ? '<button id="popupButton">Υποβολή προσφοράς</button>':""}
          </div>`;

          var marker = L.marker(
            [markerData.latitude,markerData.longitude],{title: title, icon: greenIcon})
            marker.bindPopup(popupContent)
            markersLayer.addLayer(marker);
            markersLayer.removeFrom(map);

      }
    }
  });
        var categories = []; // Array to store unique categories
      data.forEach(function(markerData) {
        // Assuming markerData has a 'category' field for each store
        if (!categories.includes(markerData.category_name)) {
          categories.push(markerData.category_name);
        }
      });
    
      // Populate the category dropdown
      populateCategoryDropdown(categories);
    
      // Attach event listener to category dropdown for filtering markers
      document.getElementById('categoryFilter').addEventListener('change', function() {
        var selectedCategory = this.value;

        // Loop through markers and apply the filter
        offersMarkersLayer.eachLayer(function(marker) {
          var markerCategory = marker.options.category; // Replace with your actual property name

          // Show markers if category is 'all' or matches the selected category
          if (selectedCategory === 'all' || markerCategory === selectedCategory) {
            marker.addTo(map);
          } else {
            map.removeLayer(marker);
          }
        });
      });
      createMarkers(stores);
      },

        error: function(jqXHR, textStatus, errorThrown) {
        console.error('AJAX Error:', errorThrown);
    }
  });
  console.log(stores)
}



function noOffersShow() {
  $("#showNoOfferStores").on('click', function () {
    if ($(this).is(':checked')) {
      markersLayer.addTo(map);
      } else {
        markersLayer.removeFrom(map);
    }
  });
}

function populateCategoryDropdown(categories) {
  var selectElement = document.getElementById('categoryFilter');

  // Add an "All Categories" option as the default
  var allOption = document.createElement('option');
  allOption.value = 'all';
  allOption.textContent = 'All Categories';
  selectElement.appendChild(allOption);

  // Loop through categories and add options to the select element
  categories.forEach(function(category) {
    var option = document.createElement('option');
    option.value = category;
    option.textContent = category;
    selectElement.appendChild(option);
  });
}







/*

 ${markerData.offer.map(offer => `<li>${offer}</li>`).join('')} 


function showStoresOnMap() {
  $.get("../php/stores.php").then(function (res) {
    var stores = JSON.parse(res);
    storeMarkers(stores);
  });
}


function storeMarkers(stores) {
  for (i in stores) {
    let name = stores[i].name;
    let marker = L.marker(
      L.latLng([stores[i].latitude, stores[i].longtitude]),
      {
        name: name,
        
      }
    );
    marker.bindPopup("<b>" + name + "</b>");
    marker.addTo(markersLayer);
  }
}

 $.ajax({
      url: '../php/stores.php', // Your PHP script to search stores by name
      type: 'GET',
      data: { name: text },
      dataType: 'json',
      success: function(json) {
          // Loop through the search results (store data)
          json.forEach(function(storeData) {
              var storeLocation = L.latLng(storeData.latitude, storeData.longitude);

              // Create a popup content for the store
              var popupContent = `
                  <div>
                      <h3>${storeData.name}</h3>
                      <!-- Other store info -->
                  </div>
              `;

              // Create a temporary marker and bind the custom popup
              var marker = L.marker(storeLocation)
                  .bindPopup(popupContent)
                  .addTo(tempMarkersLayer);
          });

          // Add the temporary markers layer to the map
          tempMarkersLayer.addTo(map);

          // Call the response function to populate the search results dropdown
          callResponse(json.map(store => store.name)); // Populate dropdown with store names
      },
      error: function(jqXHR, textStatus, errorThrown) {
          console.error('AJAX Error:', errorThrown);
      }
  });
}


 `
          <div class='popup'>
              <h3>${title}</h3>
              <p style='font-weight:bold'>Offers</p>
              <p>Product: ${markerData.product_name}</p>
              <p>Price: ${markerData.price}</p>
              <ul>
              
              </ul>
              ${distance < 500 ? '<button id="popupButton">Υποβολή προσφοράς</button>':""}
              ${distance < 500 ? '<button id="popupButton">Αξιολόγηση</button>':""}
          </div>`;



          function createPopupContent() {
  var content = '<div class="popup">';
  content += '<h3>${title}</h3>'; // Replace with actual store name
  content += '<p style="font-weight: bold;">Offers</p>';

  offers.forEach(function(offer) {
    content += `<p>Product: ${offer.productName}</p>`;
    content += `<p>Price: ${offer.price}</p>`;
  });

  content += '</div>';
  return content;
}






SWSTOOOOOOOOOOOOOOOO
if (markerData.price == null || markerData.price == undefined) {
          var popupContent =  `
          <div class='popup'>
              <h3>${title}</h3>
              ${distance < 500 ? '<button id="popupButton">Υποβολή προσφοράς</button>':""}
          </div>`;

            var marker = L.marker(
            [markerData.latitude, markerData.longitude],{title: title, icon: greenIcon})
            marker.bindPopup(popupContent)
            markersLayer.addLayer(marker);
            markersLayer.removeFrom(map);
        }

var OfferspopupContent =`
          <div class='popup'>
            <h3>${title}</h3>
            <p style='font-weight:bold'>Offers</p>
            ${offers.map(offer => `
              <p>Product: ${offer.product_name}</p>
              <p>Price: ${offer.price}</p>
            `).join('')}
            ${distance < 500 ? '<button id="popupButton">Υποβολή προσφοράς</button>':''}
            ${distance < 500 ? '<button id="popupButton">Αξιολόγηση</button>':''}
          </div>`;

          var marker = L.marker(
            [markerData.latitude, markerData.longitude],{title: title, icon: orangeIcon , category:markerData.category_name})
            marker.bindPopup(OfferspopupContent)
            offersMarkersLayer.addLayer(marker);
*/
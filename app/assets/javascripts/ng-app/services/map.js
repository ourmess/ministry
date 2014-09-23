angular.module('trash')
	.factory('mapService', function ($http, $q) {
		var api = {},
			map;

		api.getAllUsers = function () {
			var deferred = $q.defer();
			$http.get('/api/v1/participants/find_all').then(function (body) {
				deferred.resolve(body.data);
			}, function (reason) {
				console.log(reason);
				deferred.reject(reason);
			});
			return deferred.promise;
		};

		api.initPoints = function () {
			map = (map || {
        		center: {},
        		markers: [],
        		layers: {
        			baselayers: {
        				osm: {
        					name: 'OpenStreetMap',
        					url: 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        					type: 'xyz'
        				}
        			},
        			overlays: {
        				heatmap: {
        					name: 'Heat Map',
							type: 'heatmap',
							visible: true,
							data: []
						},
						waste: {
							name: 'Waste',
							type: 'group',
							visible: false,
							data: []
						}
        			}
        		}
        	});
        	return map;
        };

        api.searchMap = function (search) {
			var deferred = $q.defer();
			var data = {
				search_data: {
					search_term: search
				}
			};
			$http.post('/api/v1/contributions/find_all_by_search_term', data).then(function (body) {
				console.log(body.data.center.lat);
				console.log(body.data.center.lon);
				map.center = { lat: body.data.center.lat, lng: body.data.center.lon, zoom: 10 };
				map.markers = body.data.markers;
				deferred.resolve(map);
			}, function (reason) {
				console.log(reason);
				deferred.reject(reason);
			});
			return deferred.promise;
		};

		api.getPoints = function () {
			var deferred = $q.defer();
			$http.get('/api/v1/contributions/find_all').then(function (body) {
				angular.forEach(body.data, function(snap) {
					var latitude = snap.location[0],
						longitude = snap.location[1],
						cat_name = snap.category_name,
						full_res_url = snap.full_res_url;
					map.layers.overlays.heatmap.data.push( [latitude, longitude, 0.5] );
					//map.layers.overlays.waste.data.push( [lat, lon, 0.4] );
					map.markers = [];
					map.markers.push(
						{
							image: full_res_url,
							layer: cat_name,
                        	lat: latitude,
                        	lng: longitude,
                        	//message: "I'm a static marker with defaultIcon",
                        	focus: false,
                        	icon: {
                        		iconSize: [25,41], //50,82
                        		iconAnchor: [13, 41]
                        	}
                    	}
					);
				});

                //['34.397562', '-119.726429', 1] red
                //['34.397562', '-119.726429', 0.8] red center yellow border green border light blue border
                //['34.397562', '-119.726429', 0.7] dark yellow center green border light blue border
                //['34.397562', '-119.726429', 0.6] yellow center green center light blue border
                //['34.397562', '-119.726429', 0.5] green center light blue border
                //['34.397562', '-119.726429', 0.4] light blue
                //['34.397562', '-119.726429', 0.2] nothing

                map.center = { lat: 34.420831, lng: -119.698190, zoom: 10 };

				deferred.resolve(map);
			}, function (reason) {
				console.log(reason);
				deferred.reject(reason);
			});
			return deferred.promise;
		};

		return api;
	});
angular.module('trash')
    .controller('MapCtrl', ['$scope', 'mapService', function ($scope, mapService) {

        angular.extend($scope, mapService.initPoints() );

        mapService.getPoints().then(function (data) {
        	angular.extend($scope, data);
        });

        mapService.getAllUsers().then(function (data) {
        	$scope.users = data;
        });

        $scope.$on('leafletDirectiveMarker.click', function(e, args) {
        	// Args will contain the marker name and other relevant information
        	console.log(args.leafletEvent.target.options.image);
        });
        /*
        $scope.$on('leafletDirectiveMarker.popupopen', function(e, args) {
        	// Args will contain the marker name and other relevant information
        	console.log("Leaflet Popup Open");
        });
        $scope.$on('leafletDirectiveMarker.popupclose', function(e, args) {
        	// Args will contain the marker name and other relevant information
        	console.log("Leaflet Popup Close");
        });*/

		$scope.searchMap = function (search) {
			console.log(search);
			mapService.searchMap(search).then(function (data) {
        		angular.extend($scope, data);
        	});
		};
       

    }]);
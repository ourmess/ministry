angular
    .module('trash', [
        'ngRoute',
        'templates',
        'leaflet-directive'
    ]).config(function ($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: 'map.html',
                controller: 'MapCtrl'
            });
        $locationProvider.html5Mode(true);
    });
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

@registryadmin = angular.module('registryadmin',['ngRoute', 'ngResource',])

@registryadmin.config( ($routeProvider) ->
  $routeProvider
  .when("/", {
    templateUrl: 'templates/home.html',
    controller: 'RegistryAdminCtrl'
    })
  .when("/images", {
    templateUrl: 'templates/images.html',
    controller: 'RegistryImagesCtrl'
  })
  .otherwise({
      templateUrl: 'templates/home.html',
      controller: 'RegistryAdminCtrl'
    })
)

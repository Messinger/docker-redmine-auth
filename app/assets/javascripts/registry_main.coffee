# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

@registryadmin = angular.module('registryadmin',['ngResource','ngCookies','ui.router','ui.bootstrap','angularModalService'])

@registryadmin.config([

  "$stateProvider"
  "$urlRouterProvider"
  "$locationProvider"

  ($stateProvider,$urlRouterProvider,$locationProvider) ->

    $locationProvider.html5Mode(true)
    $urlRouterProvider.otherwise("/");

    mainLayout = {
      name: "mainLayout"
      abstract: true
      templateUrl: "views/main.html"
    }

    $stateProvider.state(mainLayout)

    registryOverview = {
      name: "registryOverview"
      url: "/admin/Registry"
      templateUrl: "views/home.html"
      parent: mainLayout
      params: {}
    }
    $stateProvider.state(registryOverview)

    home = {
      name: "home"
      url: "/"
      params: {
        trackingName: null
      }
      controller: ["$state", ($state) ->
        $state.go(registryOverview)
      ]
    }
    $stateProvider.state(home)

    home_admin = {
      name: "home_admin"
      url: "/admin"
      params: {
        trackingName: null
      }
      controller: ["$state", ($state) ->
        $state.go(registryOverview)
      ]
    }
    $stateProvider.state(home_admin)

    repositoryView = {
      name: "repositoryView"
      url: "/admin/Repository/:repository"
      templateUrl: "views/repository.html"
      parent: mainLayout
      params: {
        repository: ""
      }
    }
    $stateProvider.state(repositoryView)

    loginView = {
      name: "login"
      url: "/admin/Login"
      templateUrl: "views/login.html"
      parent: mainLayout
      params: {
        trackingName: "login"
      }
    }
    $stateProvider.state(loginView)
])

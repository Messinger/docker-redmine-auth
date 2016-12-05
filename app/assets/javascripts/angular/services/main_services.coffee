initialcalldone = false

@registryadmin.service('mainService',[
  "$rootScope"
  "$state"
  "$cookies"

  ($rootScope,$state,$cookies) ->
    goHome = () ->
      $state.go('registryOverview')

    $rootScope.goHome = goHome

    isLoggedIn = () ->
      unless initialcalldone
        initialcalldone = true
        globaldata = $cookies.getObject('dockeradmin')
        if $rootScope.globals == undefined && globaldata != undefined
          $rootScope.globals = globaldata

      $rootScope.globals != undefined  && $rootScope.globals.currentUser != undefined

    $rootScope.isLoggedIn = isLoggedIn

    {
      goHome: goHome
      isLoggedIn: isLoggedIn
    }

])

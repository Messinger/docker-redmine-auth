@registryadmin.service('mainService',[
  "$rootScope"
  "$state"
  ($rootScope,$state) ->
    goHome = () ->
      $state.go('registryOverview')

    $rootScope.goHome = goHome

    {
      goHome: goHome
    }
])

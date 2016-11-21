
@registryadmin.controller 'RegistryLoginCtrl', [
  "$scope"
  "registrydataService"
  "registrystatusService"
  "$q"
  ($scope,registrydataService,registrystatusService,$q) ->
    scopeDestroyed = false

    registrystatusService.clearCredentials()

]

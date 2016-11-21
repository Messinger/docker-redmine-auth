
@registryadmin.controller 'RegistryLoginCtrl', [
  "$scope"
  "registrydataService"
  "registryloginService"
  "$q"
  ($scope,registrydataService,registryloginService,$q) ->
    scopeDestroyed = false

    registryloginService.clearCredentials()

]

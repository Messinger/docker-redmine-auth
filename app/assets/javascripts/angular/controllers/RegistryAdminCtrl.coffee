@registryadmin.controller 'RegistryAdminCtrl', ($scope,registrydataService) ->


  
  $scope.startmessage = registrydataService.get('/')

  return
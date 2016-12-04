@registryadmin.controller 'ModalController', ($scope,close) ->
  $scope.close = (result) ->
    close(result,500);

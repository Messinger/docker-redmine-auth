@registryadmin.directive("manifestDetail",[
    () ->
      {
        templateUrl: "views/partials/manifest-detail.html"
        scope: true
        link: (scope,el,attrs) ->
          angular.extend(scope, scope.$eval(attrs.manifestDetail))
      }
  ]
)

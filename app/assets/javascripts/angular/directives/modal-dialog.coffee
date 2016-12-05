@registryadmin.directive("modalDialog",[
  "$timeout"
  "$http"
  "modalService"
  ($timeout,$http,modalService) ->
    {
      restrict: "A"
      replace: true
      scope: true
      templateUrl: "views/partials/modal-dialog.html"
      link: (scope, theelement) ->
        element = $(theelement)
        retVal = undefined

        modalService.on("openDialog", (event, options) ->
          template = "views/partials/modals/#{dialogTypes[options.dialogtype]}.html"

          scope.dialog = options.data
          scope.template = null
          retVal = false

          if (!options.data.dialog)
            element.removeAttr("role")
          else
            element.attr("role", "dialog")

          $http.get(template).then(() ->
            $timeout(() ->
              scope.template = template
              $timeout(() ->
                element.modal()
                true
              )
            )
          )
        )
        modalService.on("closeDialog", () ->
          retVal = false
          element.modal("hide")
          retVal
        )

        scope.confirm = () ->
          retVal = true
          element.modal("hide")
          retVal

        scope.cancel = () ->
          retVal = false
          element.modal("hide")
          retVal

        element.on("hide.bs.modal", () ->
          modalService.hasClosed(retVal)
        )
      }
])

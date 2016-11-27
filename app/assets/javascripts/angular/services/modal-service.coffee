@registryadmin.service('modalService',[
  "$q"
  ($q) ->
    modal_closed_defer = null

    modalService = {
      open: (dialogtype = dialogTypes.custom, data = {}) ->
        if modal_closed_defer == null
          modal_closed_defer = $q.defer()
          $(modalService).trigger('openDialog', {
            dialogtype: dialogtype
            data: data
          })
          modal_closed_defer.promise
        else
          $q.reject()

      openCustom: (data = {}) ->
        @open(dialogTypes.custom, data)

      openAlert: (data) ->
        defaults = {
          title: null
          message: null
          confirm: "OK"
          data: {
            title: null
            message: null
          }
          dialog: true
        }
        modalService.open(dialogTypes.alert, angular.extend({}, defaults, data))

      openConfirm: (data) ->
        defaults = {
          title: null
          text: null
          cancel: "Cancel"
          confirm: "Ok"
          data: {
            title: null
            text: null
          }
          dialog: true
        }
        modalService.open(dialogTypes.confirm, $.extend(true, {}, defaults, data))

      close: () ->
        $(modalService).trigger("closeDialog")

      on: (type, cb) ->
        $(modalService).on(type, cb)

      hasClosed: (confirm) ->
        modal_closed_defer.resolve(confirm)
        modal_closed_defer = null

    }
    modalService
])

App.users = App.cable.subscriptions.create {
    channel: "UsersChannel"
  },
  connected: ->

  disconnected: ->

  received: (data) ->
    user = $(".user-#{data['user_id']}")
    user.toggleClass 'online', data['online']

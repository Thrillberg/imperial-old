App.games = App.cable.subscriptions.create {
    channel: "GamesChannel"
    game_id: ''
  },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#games').append data['game']


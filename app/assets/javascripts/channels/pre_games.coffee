App.pre_games = App.cable.subscriptions.create {
    channel: "PreGamesChannel"
    game_id: ''
  },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#pre_games').append data['pre_game']


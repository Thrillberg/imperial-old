App.pre_games = App.cable.subscriptions.create {
    channel: "PreGamesChannel"
  },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    if data['pre_game']
      $('#pre_games').append data['pre_game']
      $('p').remove '.sorry'
    else if data['user']
      $('#players').append data['user']


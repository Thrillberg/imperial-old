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

  new_game: (game) ->
    @perform 'new_game', game: game

  $(document).on 'click', '[type="submit"]', (event) ->
    App.games.new_game event.target.value
    event.target.value = ''
    event.preventDefault()

  App.next_turn = App.cable.subscriptions.create {
      channel: "NextTurnChannel",
    },
    connected: ->
    disconnected: ->
    received: (game_id) ->
      window.location.href = '/games/' + game_id

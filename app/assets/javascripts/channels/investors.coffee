  App.investors = App.cable.subscriptions.create {
      channel: "InvestorsChannel",
    },
    connected: ->
    disconnected: ->
    received: (data) ->
      if data.bond_id
        window.location.href = '/games/' + data.game_id + '/investors/' + data.investor_id
      if data.investor_user_id == $('#imperial').data('current-user-id')
        window.location.href = '/games/' + data.game_id + '/investors/' + data.investor_id + '/investor_turn'

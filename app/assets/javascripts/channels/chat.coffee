App.chat = App.cable.subscriptions.create "ChatChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->

  reply: (data) ->
    @perform('reply',
      session_token: data['session_token'],
      message: data['message']
    )
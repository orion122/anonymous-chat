# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'keypress', '.input-box_text', (e) ->
  ###$('div[data-session-token]').each ->
    sessionToken = $(this).data('session-token')###

  session_token = new URLSearchParams(window.location.search).get('session_token');
  chat_token = window.location.pathname.split('/')[2];

  if e.keyCode == 13 and e.target.value
    App.chat.reply({
      'session_token': session_token,
      'chat_token': chat_token,
      'message': e.target.value
    })
    e.target.value = ''
    e.preventDefault()

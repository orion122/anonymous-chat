# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'keypress', '.input-box_text', (e) ->
  $('div[data-session-token]').each ->
    sessionToken = $(this).data('session-token')

  chat_id = $('.input-box_text').attr('id').split('_')[1]

  if e.keyCode == 13 and e.target.value
    App.chat.reply({
      'chat_id': chat_id,
      'my_name': 'me',
      'message': e.target.value
    })
    e.target.value = ''
    e.preventDefault()

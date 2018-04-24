# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'keypress', '.input-box_text', (e) ->
  if e.keyCode == 13 and e.target.value
    App.chat.reply({
      'session_token': gon.session_token,
      'message': e.target.value
    })
    e.target.value = ''
    e.preventDefault()
#    console.log(gon.sorted_messages)

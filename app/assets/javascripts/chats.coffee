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
    getMessages()


setInterval (->
  if (window.location.pathname == "/chats/#{gon.chat_token}")
    getMessages()
), 5000


getMessages = () ->
  $.ajax({
    url: "/chats/messages?chat_token=#{gon.chat_token}",
    type: "GET"
    success: (data) ->
      allMessages = data.reduce(((init, messageObject) ->
        init + "<p>#{messageObject.session_id}: #{messageObject.message}</p>"
      ), '')

      $messages = $("#messages")
      $messages.html allMessages
      $scroll = $('#messages-history')
      $scroll.scrollTop($messages.prop("scrollHeight"))
  });
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'keypress', '.input-box_text', (e) ->
  if e.keyCode == 13 and e.target.value
    saveMessage({
      'session_token': localStorage.getItem('session_token'),
      'message': e.target.value
    })
    e.target.value = ''
    e.preventDefault()
    getMessages()


setInterval (->
  if (window.location.pathname == "/chats/#{getLastURLSegment(window.location.href)}")
    getMessages()
), 5000


getMessages = () ->
  $.ajax({
    url: "/chats/messages?chat_token=#{getLastURLSegment(window.location.href)}",
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


saveMessage = (data) ->
  $.post '/chats/save_message', {
    'session_token': data['session_token'],
    'message': data['message']
  }, onAjaxSuccess


onAjaxSuccess = (data) ->
  console.log(data)


getLastURLSegment = (url) ->
  url.split('/').reverse()[0];
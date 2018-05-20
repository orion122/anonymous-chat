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
  if (window.location.pathname == "/chats/#{getChatToken(window.location.href)}")
    getMessages()
), 9995000


getMessages = () ->
  $.ajax({
    url: "/chats/#{getChatToken(window.location.href)}/messages",
    type: "GET"
    beforeSend: (request) ->
      request.setRequestHeader 'X-Auth-Token', localStorage.getItem('session_token')
    success: (data) ->
#      messagesIds = data.reduce(((ids, messageObject) ->
#        ids.push(messageObject.id)
#        return ids
#      ), [])
      allMessages = data.reduce(((init, messageObject) ->
        init + "<p>#{messageObject.session_id}: #{messageObject.message} (#{messageObject.state})</p>"
      ), '')
      renderMessages(allMessages)
      setStateRead()
  });


setStateRead = () ->
  $.ajax({
    url: "/chats/#{getChatToken(window.location.href)}/messages",
    type: "POST"
    beforeSend: (request) ->
      request.setRequestHeader 'X-Auth-Token', localStorage.getItem('session_token')
    data: { 'setStateRead': true }
  });


renderMessages = (messages) ->
  $messages = $("#messages")
  $messages.html messages
  $scroll = $('#messages-history')
  $scroll.scrollTop($messages.prop("scrollHeight"))


saveMessage = (data) ->
  $.ajax({
    url: "/chats/#{getChatToken(window.location.href)}/messages",
    type: "POST"
    beforeSend: (request) ->
      request.setRequestHeader 'X-Auth-Token', localStorage.getItem('session_token')
    data: { 'message': data['message'] }
  });


$(window).on 'load', ->
  if (window.location.pathname == "/")
    localStorage.removeItem('session_token');
    localStorage.setItem('session_token', gon.session_token);


getChatToken = (url) ->
  url.split('/').reverse()[0];
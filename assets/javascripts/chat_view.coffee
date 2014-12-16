# Responsible for tieing the view layer to the ChatSession
class ChatView
	chatScrollContainer: null
	chatContainer: null
	@inputField: null
	@submitButton: null
	session: null

	constructor: (@chatHandler) ->
		@chatScrollContainer = document.querySelector('.chat-container')
		@chatContainer = document.querySelector('.chat-message-container')
		@inputField = document.querySelector('.chat-input-field')
		document.addEventListener 'chat::activeSessionChanged', @onActiveSessionChanged
		@inputField.addEventListener 'keyup', @onKeyUp
		@submitButton = document.querySelector('.chat-submit-button')
		@submitButton.addEventListener 'click', @onSubmit

	onActiveSessionChanged: (event) =>
		@bindToActiveSession(event.detail)
		@resetView()
		@drawMessages()

	resetView: () ->
		# Used to transition state , clears DOM
		@chatContainer.innerHTML = ''
		@inputField.value = ''
		@inputField.focus()

	onKeyUp: (event) =>
		if @session and @inputField.value
			if event.keyCode == 13 #New Line
				@session.sendTextMessage(@inputField.value)
				@inputField.value = ''
				@inputField.focus()
			else
				@session.onTypingStarted()
		return true
		
	onSubmit: (event) =>
		if @session and @inputField.value
			@session.sendTextMessage(@inputField.value)
			@inputField.value = ''
			@inputField.focus()

	bindToActiveSession: (session) ->
		# Unbind old events
		if @session
			document.removeEventListener("chatSession::message::#{@session.recipient}", @onMessageReceived)
			document.removeEventListener("chatSession::typingStateChanged::#{@session.recipient}", @onTypingStateChanged)

		@session = session

		document.addEventListener("chatSession::message::#{@session.recipient}", @onMessageReceived)
		document.addEventListener("chatSession::typingStateChanged::#{@session.recipient}", @onTypingStateChanged)
		console.log ("Bindings Initialized")

	onMessageReceived: (evt) =>
		console.log("Received Chat Message #{evt.detail}")
		message = evt.detail
		@chatContainer.innerHTML += message.render()
		@chatScrollContainer.scrollTop = @chatScrollContainer.scrollHeight;

	onTypingStateChanged: (event) ->

	drawMessages: () =>
		session = @session
		for message in session.messageBuffer
			@chatContainer.innerHTML += message.render()
		# TODO: Scroll to bottom
		@chatScrollContainer.scrollTop = @chatScrollContainer.scrollHeight;


document.addEventListener "DOMContentLoaded", ->
	window.ChatView = new ChatView(ChatHandler)
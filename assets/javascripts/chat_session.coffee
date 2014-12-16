class @ChatSession
	messageBuffer: []
	isTyping: false
	isRecipientTyping: false
	_typingTimer: null

	constructor: (@chatHandler, @recipient) ->
		document.addEventListener "chat::message", @onMessageReceived

	#Sends JSON Formatted Object to Recipient
	sendMessage: (message) =>
		if message
			message.recipient = @recipient
			@chatHandler._stompClient.send("/app/chat", {}, JSON.stringify(message));

	sendTextMessage: (text) =>
		if text
			if text.toLowerCase().indexOf('sensitive') >= 0
				sensitive = true
			else
				sensitive = false
			@sendMessage({text: text, isSensitive: sensitive})

	onTypingStarted: =>
		if @_typingTimer
			clearTimeout @_typingTimer
			@_typingTimer = null
		@isTyping = true
		@sendMessage({typingState:true})
		@_typingTimer = setTimeout @onTypingStopped, 5000

	onTypingStopped: =>
		@isTyping = false
		@sendMessage({typingState:false})
		@_typingTimer = null

	setRecipientTypingState: (_typingState) =>
		@isRecipientTyping = false

	onMessageReceived: (evt) =>
		message = evt.detail
		if message.sender is @recipient
			console.log "Received Message", message
			if message.typingState isnt null
				@setRecipientTypingState message.typingState
			else
				@setRecipientTypingState false

			@messageBuffer.push(new ChatMessage(@recipient, message.text, message.sendDate, message.isSensitive))
			@redrawMessages()

	redrawMessages: =>
		console.log "TODO: Figure out how to call redraw methods"

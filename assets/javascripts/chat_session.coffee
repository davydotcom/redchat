class @ChatSession
	messageBuffer: []
	isTyping: false
	isRecipientTyping: false
	_typingTimer: null

	constructor: (@chatHandler, @recipient) ->
		document.addEventListener "chat::message", @onMessageReceived
		document.addEventListener "chatView::typingStarted::#{@recipient}", @onTypingStarted
		document.addEventListener "chatView::typingStopped::#{@recipient}", @onTypingStopped

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
		unless @isTyping
			@isTyping = true
			@sendMessage({typingState:true})
		@_typingTimer = setTimeout @onTypingStopped, 5000

	onTypingStopped: =>
		@isTyping = false
		@sendMessage({typingState:false})
		@_typingTimer = null

	setRecipientTypingState: (_typingState) =>
		@isRecipientTyping = _typingState
		EventService.dispatchEvent "chatSession::typingStateChanged::#{@recipient}", _typingState

	onMessageReceived: (evt) =>
		message = evt.detail
		if message.sender is @recipient or message.recipient is @recipient
			if message.sender is @recipient
				if message.typingState isnt null
					@setRecipientTypingState message.typingState
				else
					@setRecipientTypingState false

			if message.text
				chatMessage = new ChatMessage(message.sender, message.text, message.sendDate, message.isSensitive, message.sender != @recipient)
				@messageBuffer.push(chatMessage)
				EventService.dispatchEvent "chatSession::message::#{@recipient}", chatMessage

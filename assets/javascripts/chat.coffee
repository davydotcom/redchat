class ChatHandler
	_stompClient: null
	_socket: null
	_whoami: null
	chatSessions: {}
	activeSession: null

	constructor: (@username, @password) ->
		console.log "Initializing Chat Handler for #{@username}"
		@_socket = new SockJS('/chat')
		@_stompClient = Stomp.over(@_socket)

	connect: =>
		@_stompClient.connect @username, @password, @onConnected
	
	findOrcreateChatSession: (recipient) =>
		chatSession = @chatSessions[recipient]
		unless chatSession
			@chatSessions[recipient] = chatSession = new ChatSession(@, recipient)
		chatSession

	setActiveSession: (recipient) =>
		chatSession = @findOrcreateChatSession(recipient)
		if @activeSession isnt chatSession
			@activeSession = chatSession
			event = new CustomEvent('chat::activeSessionChanged', detail: @activeSession)
			document.dispatchEvent event

	onConnected: (frame) =>
		@whoami = frame.headers['user-name']
		event = new CustomEvent('sockConnected',{detail: @})
		@_stompClient.subscribe '/user/queue/messages', @onMessageReceived
		document.dispatchEvent event

	onMessageReceived: (message) =>
		messageBody = JSON.parse(message.body)
		chatSession = @findOrcreateChatSession(messageBody.sender)
		# We throw the message onto an event bus so multiple subscribers can fetch it if necessary
		event = new CustomEvent('chat::message',detail: messageBody)
		document.dispatchEvent event

@ChatHandler = new ChatHandler(window.username,'pass') 

document.addEventListener "DOMContentLoaded", @ChatHandler.connect

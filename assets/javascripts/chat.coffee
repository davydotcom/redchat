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
			EventService.dispatchEvent 'chat::activeSessionChanged', @activeSession

	onConnected: (frame) =>
		@whoami = frame.headers['user-name']
		@_stompClient.subscribe '/user/queue/messages', @onMessageReceived
		EventService.dispatchEvent 'sockConnected', @

	onMessageReceived: (message) =>
		messageBody = JSON.parse(message.body)
		chatSession = @findOrcreateChatSession(messageBody.sender)
		# We throw the message onto an event bus so multiple subscribers can fetch it if necessary
		EventService.dispatchEvent 'chat::message', messageBody

@ChatHandler = new ChatHandler(window.username,'pass') 

document.addEventListener "DOMContentLoaded", @ChatHandler.connect

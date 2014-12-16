class ChatHandler
	_stompClient: null
	_socket: null
	_whoami: null
	chatSessions: {}

	constructor: (@username, @password) ->
		console.log "Initializing Chat Handler for #{@username}"
		@_socket = new SockJS('/chat')
		@_stompClient = Stomp.over(@_socket)

	connect: =>
		@_stompClient.connect @username, @password, @onConnected
	
	createChatSession: (recipient) =>
		chatSession = @chatSessions[recipient]
		unless chatSession
			@chatSessions[recipient] = chatSession = new ChatSession(@, recipient)
		chatSession

	onConnected: (frame) =>
		@whoami = frame.headers['user-name']
		event = new CustomEvent('sockConnected',{detail: @})
		@_stompClient.subscribe '/user/queue/messages', @onMessageReceived
		document.dispatchEvent event

	onMessageReceived: (message) =>
		messageBody = JSON.parse(message.body)
		chatSession = @chatSessions[messageBody.sender]
		unless chatSession
			@chatSessions[messageBody.sender] = new ChatSession(@, messageBody.sender)
		# We throw the message onto an event bus so multiple subscribers can fetch it if necessary
		event = new CustomEvent('chat::message',detail: messageBody)
		document.dispatchEvent event

@ChatHandler = new ChatHandler(window.username,'pass') 

document.addEventListener "DOMContentLoaded", @ChatHandler.connect

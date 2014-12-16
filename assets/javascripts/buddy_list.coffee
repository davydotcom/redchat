class BuddyList
	activeUsers: []
	chatHandler: null

	constructor: ->
		document.addEventListener 'sockConnected', @onSockConnected

	onSockConnected: (sockEvent) =>
		@chatHandler = sockEvent.detail
		@notifyServer()
		@chatHandler._stompClient.subscribe '/topic/active', @onActiveUserPing

	onActiveUserPing: (activeMembers)=>
		chatHandler = @chatHandler
		@activeUsers = JSON.parse(activeMembers.body).filter((x) -> x != chatHandler.username).map (username) ->
			{username: username}
		# TODO: Refresh DOM with Active User List
		console.log "Active Users List", @activeUsers
		@notifyServer()
		@redrawBuddyList()
	notifyServer: ->
		@chatHandler._stompClient.send('/app/activeUsers',{}, @chatHandler.username)

	redrawBuddyList: =>
		buddyEl = document.querySelector('.buddy-list-wrapper')
		buddyEl.innerHTML = Handlebars.templates['buddy-list']({activeUsers: @activeUsers})
		

@BuddyList = new BuddyList()
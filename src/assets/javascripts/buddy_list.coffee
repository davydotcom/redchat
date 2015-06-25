class BuddyList
	activeUsers: []
	chatHandler: null
	@session

	constructor: ->
		document.addEventListener 'sockConnected', @onSockConnected
		document.addEventListener 'click', @onClick
		document.addEventListener 'chat::activeSessionChanged', @onActiveSessionChanged

	onActiveSessionChanged: (event) =>
		@session = event.detail
		for activeUser in @activeUsers
			if activeUser.username == @session.recipient
				activeUser.active = true
			else
				activeUser.active = false
		@redrawBuddyList()

	onClick: (event) =>
		if event.target.classList.contains('buddy-link')
			username = event.target.getAttribute('data-user')
			@chatHandler.setActiveSession(username)
			
	onSockConnected: (sockEvent) =>
		@chatHandler = sockEvent.detail
		@notifyServer()
		@chatHandler._stompClient.subscribe '/topic/active', @onActiveUserPing

	onActiveUserPing: (activeMembers)=>
		chatHandler = @chatHandler
		session     = @session
		activeChatFound = false
		@activeUsers = JSON.parse(activeMembers.body).filter((x) -> x != chatHandler.username).map (username) ->
			result = {username: username, active: false}
			if session and username == session.recipient
				console.log("Checking for active #{session.recipient} on #{username}")
				activeChatFound = true
				result.active = true
			result
		
		@notifyServer()
		@redrawBuddyList()

		if !activeChatFound and @activeUsers.length > 0
			@chatHandler.setActiveSession(@activeUsers[0].username)

	notifyServer: ->
		@chatHandler._stompClient.send('/app/activeUsers',{}, @chatHandler.username)

	redrawBuddyList: =>
		buddyEl = document.querySelector('.buddy-list-wrapper')
		render =  Handlebars.templates['buddy-list']({activeUsers: @activeUsers})
		buddyEl.innerHTML = render
		

@BuddyList = new BuddyList()
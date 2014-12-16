class @ChatMessage
	@_identifierSeed: 1
	@id: null
	dateExpires: null
	@dateFormatted: null
	constructor: (@sender, @text, @sendDate, @isSensitive, @selfWritten) ->
		@dateExpires = new Date().getTime() + 5*60*1000 
		@id = ChatMessage._identifierSeed++
		@dateFormatted = moment(new Date(@sendDate)).format("LT")
	
	render: =>
		Handlebars.templates['chat-message'](@)
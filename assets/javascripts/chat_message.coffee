#=require marked

class @ChatMessage
	@_identifierSeed: 1
	@id: null
	dateExpires: null
	@dateFormatted: null
	@textFormatted: null
	constructor: (@sender, @text, @sendDate, @isSensitive, @selfWritten) ->
		@dateExpires = new Date().getTime() + 5*60*1000 
		@id = ChatMessage._identifierSeed++
		@textFormatted = marked(@text)
		@dateFormatted = moment(new Date(@sendDate)).format("LT")
	
	render: =>
		Handlebars.templates['chat-message'](@)
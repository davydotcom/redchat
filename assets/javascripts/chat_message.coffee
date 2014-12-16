class @ChatMessage
	dateExpires: null
	constructor: (@sender, @text, @sendDate, @isSensitive) ->
		@dateExpires = new Date().getTime() + 5*60*1000 
		
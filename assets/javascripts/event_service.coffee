class @EventService
	@dispatchEvent: (name, detail) ->
		evt = document.createEvent("CustomEvent")
		evt.initCustomEvent(name, false, false, detail)
		document.dispatchEvent evt
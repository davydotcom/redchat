navWrapper = null
toggleButton = null

init = ->
	navWrapper   = document.querySelector '.nav-wrapper' 
	toggleButton = document.querySelector '.nav-toggle-link'
	toggleButton.addEventListener 'click', toggleNavigation
	document.addEventListener 'click', onDocumentClicked, true

onDocumentClicked = (evt) ->
	if isExpanded()
		clearNavigation()
		evt.stopPropagation();
		evt.preventDefault();
		return false

toggleNavigation = ->
	navWrapper.classList.toggle('expanded')

clearNavigation = ->
	navWrapper.classList.remove('expanded')	

isExpanded = ->
	navWrapper.classList.contains('expanded')

document.addEventListener( "DOMContentLoaded", init, false )

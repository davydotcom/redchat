#=require sockjs
#=require stomp
#=require moment
#=require handlebars.runtime.js
#=require_tree .
#=require_self


setInterval(->
	console.log("Window Height #{window.innerHeight}")
	document.body.style.height = window.innerHeight;
, 150)


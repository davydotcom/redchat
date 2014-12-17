#=require sockjs
#=require stomp
#=require moment
#=require handlebars.runtime.js
#=require_tree .
#=require_self


setInterval(->
	# console.log("Window Height #{window.innerHeight}")
	# document.body.style.height=200;
	document.body.style.height = "#{window.innerHeight}px";
	window.scrollTo(0, 0);
, 150)


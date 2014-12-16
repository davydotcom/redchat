package redchat

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.web.servlet.ModelAndView
@Controller
class HomeController {
 
    @RequestMapping("/")
    ModelAndView index() {
    	def authentication = SecurityContextHolder.getContext().getAuthentication();
		String username = authentication.getName();
		println "Username is ${username}"
		ModelAndView mav = new ModelAndView("index");
	    mav.addObject("username", username);
	    return mav;
    }
}
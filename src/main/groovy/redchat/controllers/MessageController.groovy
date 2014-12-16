package redchat.controllers
 
import java.security.Principal;
import javax.inject.Inject;
import org.springframework.messaging.Message;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import redchat.models.ChatMessage
import redchat.services.ActiveUserService

@Controller
public class MessageController {
  
  private SimpMessagingTemplate template;
  private ActiveUserService activeUserService;
  
  @Inject
  public MessageController(SimpMessagingTemplate template, ActiveUserService activeUserService) {
    this.template = template
    this.activeUserService = activeUserService
  }
 
  @MessageMapping("/chat")
  public void greeting(Message<Object> message, @Payload ChatMessage chatMessage) throws Exception {
    def principal = message.headers.get(SimpMessageHeaderAccessor.USER_HEADER, Principal.class)
    String authedSender = principal.name

    chatMessage.sender = authedSender
    chatMessage.sendDate = new Date()
    if(!activeUserService.isActive(chatMessage.recipient)) {
      chatMessage.liveDelivery = false
      // TODO: Post to Mongo a persisted encrypted copy of the message for retrievel when they come online
    }

    if (authedSender != chatMessage.recipient) {
      template.convertAndSendToUser(authedSender, "/queue/messages", chatMessage);
    }
    
    template.convertAndSendToUser(chatMessage.recipient, "/queue/messages", chatMessage);
  }
 
}
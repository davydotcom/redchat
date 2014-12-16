package redchat.config;
 
import java.util.List;
 
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.converter.MessageConverter;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.messaging.handler.invocation.HandlerMethodReturnValueHandler
import org.springframework.messaging.handler.invocation.HandlerMethodArgumentResolver
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketTransportRegistration
import redchat.services.ActiveUserService
/**
 * Set up our websocket configuration, which uses STOMP, and configure our endpoints
 */
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
 
  @Override
  public void configureMessageBroker(MessageBrokerRegistry config) {
    config.enableSimpleBroker("/queue", "/topic");
    config.setApplicationDestinationPrefixes("/app");
  }

  @Override
  public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {

  }

  @Override
  public void addReturnValueHandlers(List<HandlerMethodReturnValueHandler> returnValueHandlers) {

  }
 
  @Override
  public void registerStompEndpoints(StompEndpointRegistry registry) {
    registry.addEndpoint("/chat", "/activeUsers").withSockJS();
  }
 
  @Override
  public void configureClientInboundChannel(ChannelRegistration channelRegistration) {
  }
 
  @Override
  public void configureClientOutboundChannel(ChannelRegistration channelRegistration) {
  }
 
  @Override
  public boolean configureMessageConverters(List<MessageConverter> converters) {
    return true;
  }

  @Override
  public void configureWebSocketTransport(WebSocketTransportRegistration registry) {

  }
  
  @Bean
  public ActiveUserService activeUserService() {
    return new ActiveUserService();
  }
 
}
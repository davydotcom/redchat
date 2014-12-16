package redchat.models

public class ChatMessage {
  String recipient
  String sender

  Boolean isSensitive=false //Determines default visibility state
  //Used to monitor Typing Status
  Boolean typingState=false
  Boolean liveDelivery=true //Set to false if the user is offline and it is unlikely this message will be immediately received
  //If its a message
  String text
  Date sendDate

}
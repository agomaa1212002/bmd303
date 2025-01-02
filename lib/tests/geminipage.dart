import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
class Geminipage extends StatefulWidget {
  const Geminipage({super.key});

  @override
  State<Geminipage> createState() => _GeminipageState();
}

class _GeminipageState extends State<Geminipage> {
 final Gemini gemini = Gemini.instance;
  List<ChatMessage>messages=[];
  ChatUser currentUser = ChatUser(id: "0" , firstName: "User");
  ChatUser geminiUser = ChatUser(id: "1",firstName: "Gemini",profileImage: "assets/icons/DALL·E 2024-05-28 05.28.07 - A modern and clean logo for a nutrition mobile application called DEV.JA. The logo should incorporate elements related to health, nutrition, and techn.webp");
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Gemini Chat"),
      ),
      body: _buildU(),
    );
  }
  Widget _buildU(){
 return DashChat(

     currentUser: currentUser,
     onSend: _sendmessage,
     messages: messages);
}
 void _sendmessage(ChatMessage chatMessage){
  setState(() {
    messages =[chatMessage ,...messages];
  });
  try {
  String question = chatMessage.text;
  gemini.streamGenerateContent(question).listen((event) {
    ChatMessage? lastMessage = messages.firstOrNull;
    if(  lastMessage != null && lastMessage.user == geminiUser){
      lastMessage= messages.removeAt(0);
      String response = event.content?.parts
          ?.fold("", (previous, current) => "$previous ${current.text}")?? "";
    lastMessage.text += response;
    setState(() {
      messages =[lastMessage!, ...messages];
    });
    }else{
      String response = event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}")?? "";
      ChatMessage message = ChatMessage(user: geminiUser, createdAt: DateTime.now(),
      text:response );
      setState(() {
        messages = [message,...messages];
      });
    }
  });
  }catch(e){
    print(e);
  }
 }
}

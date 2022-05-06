import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/util.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/cards/card16.dart';
import 'package:FisioLago/widgets/edit/edit32.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../main.dart';

class ChatScreen extends StatefulWidget {
  final Function(String) callback;
  const ChatScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  Stream<QuerySnapshot>? chats;
  var windowWidth;
  var windowHeight;
  TextEditingController messageEditingController = new TextEditingController();

  var _screen = 1;
  var _companionId = "";

  @override
  void dispose() {
    _scrollController.dispose();
    messageEditingController.dispose();
    for (var item in _users)
      if (item.listen != null)
        item.listen!.cancel();
    super.dispose();
  }

  Widget _chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? _listMessages(snapshot.requireData)
            : Container();
      },
    );
  }

  _listMessages(QuerySnapshot snapshot) {
    List<Widget> list = [];
    DateTime? _lastTime;
    for (var item in snapshot.docs) {
      if (item["time"] == null)
        continue;
      var _time = item["time"].toDate().toLocal();
      if (_lastTime != null)
        if (_time.year != _lastTime.year || _time.month != _lastTime.month ||
            _time.day != _lastTime.day)
          list.add(Center(child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Color(0xae1e8b93),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(DateFormat(dateFormat).format(_time)),)));
      _lastTime = _time;
      list.add(MessageTile(
        message: item["message"],
        sendByMe: user!.uid == item["sendBy"],
        time: DateFormat(getTimeFormat()).format(_time),
      ));
    }
    Future.delayed(const Duration(milliseconds: 700), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent,);
    });
    return ListView(
      controller: _scrollController,
      children: list,);
  }

  ScrollController _scrollController = new ScrollController();

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": user!.uid,
        'read': false,
        "message": messageEditingController.text,
        'time': FieldValue.serverTimestamp(),
      };

      FirebaseFirestore.instance.collection("chatRoom")
          .doc(chatRoomId)
          .collection("chats")
          .add(chatMessageMap)
          .catchError((e) {
        print(e.toString());
      });

      FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId)
          .set({"all": FieldValue.increment(1),
        "unread_$_companionId": FieldValue.increment(1),
      }, SetOptions(merge: true))
          .catchError((e) {
        print(e.toString());
      });

      FirebaseFirestore.instance.collection("settings")
          .doc("chat")
          .set({"numberChatMessages": FieldValue.increment(1)},
          SetOptions(merge: true))
          .catchError((e) {
        print(e.toString());
      });

      setState(() {
        messageEditingController.text = "";
      });
    }
  }


  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  String chatRoomId = "";
  User? user;

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  List<UserData> _users = [];

  _loadUsers() async {
    var querySnapshot = await FirebaseFirestore.instance.collection("users").get();
    querySnapshot.docs.forEach((result) {
      print(result.data());
      _users.add(UserData.fromJson(result.id, result.data()));
    });
    _redraw();
    for (var item in _users){
      log("_loadUsers item.image=${item.image}");
      if (item.image.isNotEmpty)
        item.avatarUrl = await FirebaseStorage.instance.ref(item.image).getDownloadURL();
      }
    _redraw();
    // get unread messages
    var user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return;
    for (var item in _users){
      var data = await FirebaseFirestore.instance.collection("chatRoom").doc(getChatRoomId(item.id, user.uid)).get();
      if (data.data() != null){
        if (data.data()!['all'] != null)
          item.all = data.data()!['all'];
        if (data.data()!['unread_${user.uid}'] != null)
          item.unread = data.data()!['unread_${user.uid}'];
      }
      item.listen = FirebaseFirestore.instance.collection("chatRoom")
          .doc(getChatRoomId(item.id, user.uid)).snapshots().listen((querySnapshot) {
        if (querySnapshot.data() != null) {
          if (querySnapshot.data()!['all'] != null) {
            print("all = ${querySnapshot.data()!['all']}");
            item.all = querySnapshot.data()!['all'];
          }
          if (querySnapshot.data()!['unread_${user.uid}'] != null)
            item.unread = querySnapshot.data()!['unread_${user.uid}'];
          if (_companionId == item.id){
            if (item.unread != 0){
              FirebaseFirestore.instance.collection("chatRoom").doc(getChatRoomId(item.id, user.uid)).set({
                "unread_${user.uid}" : 0,
              }, SetOptions(merge:true))
                  .catchError((e){
                print(e.toString());
              });
            }
          }
          setState(() {});
        }
      });
    }
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: (darkMode) ? Colors.black : Colors.white,
        body: Stack(
          children: <Widget>[
            if (_screen == 1)
              _listUsers(),
            if (_screen == 2)
              Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+40, bottom: 60),
                  child: _chatMessages()),
            if (_screen == 2)
              Container(
                alignment: Alignment.bottomCenter,
                width: windowWidth,
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: (darkMode) ? Colors.white : Color(0x54FFFFFF),
                  child: Row(
                    children: [
                      Expanded(child: edit32(messageEditingController, strings.get(99), // "Message ...",
                          Colors.black)),
                      SizedBox(width: 16,),
                      GestureDetector(
                        onTap: () {
                          addMessage();
                        },
                        child: Image.asset("assets/send.png",
                              height: 35, width: 35,),
                      ),
                    ],
                  ),
                ),
              ),

            appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black, strings.get(97), // Chat
                context, () {
                  if (_screen == 2){
                    _screen = 1;
                    return _redraw();
                  }
                widget.callback("root");
            })

          ],
        )

    );
  }

  _listUsers(){
    List<Widget> list = [];
    list.add(SizedBox(height: 20,));
    for (var item in _users){
      log("chat::_listUsers name=${item.name}");
      var _salonsNames = "";
      if (item.role == "owner")
        _salonsNames = strings.get(119); // "All salons",
      else
        for (var item2 in salons)
          if (item.salons.contains(item2.id))
            _salonsNames = "$_salonsNames${item2.name}\n";

      list.add(InkWell(
        onTap: (){
          item.unread = 0;
          _loadScreen2(item);
        },
        child: Card16(
          image: item.avatarUrl,
          text1: "${item.name} - ${item.role}",
          style1: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black,),
          text2: _salonsNames,
          style2: TextStyle(fontSize: 12, color: (darkMode) ? Colors.white : Colors.black,),
          radius: 60,
          text3: (item.unread == 0) ? "" : item.unread.toString(),
          text4: (item.all == 0) ? "" : item.all.toString(),
        ),
      ));
    }
    return Container(
      child: ListView(
        children: list,
      )
    );
  }

  _loadScreen2(UserData item){
    _screen = 2;
    _companionId = item.id;
    user = FirebaseAuth.instance.currentUser;
    List<String> users = [user!.uid, _companionId];
    chatRoomId = getChatRoomId(user!.uid, _companionId);
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };
    chats = null;
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom, SetOptions(merge:true)).then((value) {
      _getChats();
    }).catchError((e) {
      print(e);
    });
    setState(() {
    });
  }

  _getChats() async {
    chats = FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
    setState(() {
    });
    FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId)
        .set({
      "unread_${user!.uid}" : 0,
    }, SetOptions(merge:true))
        .catchError((e){
      print(e.toString());
    });
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String time;

  MessageTile({required this.message, required this.sendByMe, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [

            if (sendByMe)
              Container(width: 20,),
            if (sendByMe)
              Container(child: Text(time, style: TextStyle(fontSize: 12, color: (darkMode) ? Colors.white : Colors.black),),),

            Flexible(child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: sendByMe ? BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)
                ) :
                BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: sendByMe ? Color(0xffcce566) : Color(0xfff5f5f2),
              ),
              child: Text(message,
                  textAlign: TextAlign.start,
                  maxLines: 20,
                  style: TextStyle(
                    color: Color(0xff7e8299),)),
            )),

            if (!sendByMe)
              Container(child: Text(time, style: TextStyle(fontSize: 12, color: (darkMode) ? Colors.white : Colors.black),),),
            if (!sendByMe)
              Container(width: 20,),
          ],
        )
    );
  }
}



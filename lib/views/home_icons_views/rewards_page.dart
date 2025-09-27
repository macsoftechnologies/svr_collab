import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class RewardsPage extends StatefulWidget
{
  const RewardsPage({super.key});

  @override
  State<StatefulWidget> createState() => _RewardsPage();
}

class _RewardsPage extends State<RewardsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: CommonWidgets().appBar("Telegram",context),
      body:Center(
          child:Container(
            padding: EdgeInsets.all(30),

             // alignment: Alignment.topCenter,

              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Center(
            child: InkWell(
              onTap: () async {
                const url = "https://t.me/svracademy6";  // Telegram link
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Image.asset("assets/telegram.png",width: 100,height: 100,),  // Replace with your own image
            ),

              ),
              SizedBox(height: 15,),
              Text("Please join through this telegram channel for more updates",style: TextStyle(color: Colors.red,fontSize: 15)),

              SizedBox(height: 10,),
              Container(
                child: InkWell(
                  onTap: () async {
                    const url = "https://whatsapp.com/channel/0029VaA34W10LKZN0viaMH3z";  // Telegram link
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Image.asset("assets/wts.png",width: 100,height: 100,),  // Replace with your own image
                ),

              ),
              SizedBox(height: 15,),
              Text(" Join through our what's up channel for more updates",style: TextStyle(color: Colors.red,fontSize: 15)),
               SizedBox(height: 10,),

              Container (
                child: InkWell(
                  onTap: () async {
                    const url = "https://www.facebook.com/svr6academy/";  // Telegram link
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Image.asset("assets/fb.png",width: 100,height: 100,),  // Replace with your own image
                ),

              ),
              SizedBox(height: 15,),
              Text("Join our facebook account channel for more updates",style: TextStyle(color: Colors.red,fontSize: 15)),


            ] ,
          ),

      ),
      ),

    );
  }
}
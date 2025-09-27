import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svr/models/home_icons_models/profile_model.dart';
import 'package:svr/utils/colors.dart';
import 'package:svr/utils/common_widgets.dart';
import 'package:svr/view_models/home_icons_view_models/profile_view_model.dart';
import 'package:svr/views/login_page.dart';

class Profile extends StatefulWidget{
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() => _Profile();
}

class _Profile extends State<Profile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: CommonWidgets().appBar("Profile",context),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel,child ){
          if(!viewModel.fetchData && viewModel.getProfileInfo == null)
            {
              Provider.of<ProfileViewModel>(context,listen: false).fetchProfileData(context);
            }
          if(viewModel.fetchData)
            {
              return const LinearProgressIndicator();
            }
          else
            {
              ProfileModel? profileInfo = viewModel.getProfileInfo;
              return profileInfo!.userId!.isEmpty ? const Center(child: Text("No Data Found"),) : Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(58), // Image radius
                        child:
                        Image.asset('assets/logo.jpeg', fit: BoxFit.cover),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: const Text("Profile Info",textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ),
                    Card(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text("Father Name ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text("Mobile Number ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text("Email ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text("Address ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(":  ${profileInfo.name}",overflow: TextOverflow.ellipsis,),
                                  const SizedBox(height: 10,),
                                  Text(":  ${profileInfo.fathername??""}",overflow: TextOverflow.ellipsis,),
                                  const SizedBox(height: 10,),
                                  Text(":  ${profileInfo.mobileNumber}",overflow: TextOverflow.ellipsis,),
                                  const SizedBox(height: 10,),
                                  Text(":  ${profileInfo.email}",overflow: TextOverflow.ellipsis,),
                                  const SizedBox(height: 10,),
                                  Text(":  ${profileInfo.address ?? ""}",overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("DOB ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text("Hall Ticket No ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text("Gender ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text("Course ID ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text("Remarks ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(":  ${profileInfo.dob ??""}",overflow: TextOverflow.ellipsis,),
                                  const SizedBox(height: 10,),
                                  Text(":  ${profileInfo.hallticketno??""}",overflow: TextOverflow.ellipsis,),
                                  const SizedBox(height: 10,),
                                  Text(":  ${profileInfo.gender??""}",overflow: TextOverflow.ellipsis,),
                                  const SizedBox(height: 10,),
                                  Text(":  ${profileInfo.courseId??""}",overflow: TextOverflow.ellipsis,),
                                  const SizedBox(height: 10,),
                                  Text(":  ${profileInfo.remark ?? ""}",overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 100,
                              width: MediaQuery.of(context).size.width*0.4,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("View Hall Ticket ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text("Update Profile Info",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(onPressed: (){}, icon: const Icon(Icons.remove_red_eye_rounded)),
                                  const SizedBox(height: 10,),
                                  IconButton(onPressed: (){}, icon: const Icon(Icons.edit_note_sharp)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 0,),
                    ElevatedButton(onPressed: (){
                      logout();
                    }, child: Text("Logout",textAlign:TextAlign.center,))
                  ],
                ),
              );
            }
        },
      ),
    );
  }

  Future<void>logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear user data and set login status to false
    await prefs.remove('userData');
   // await prefs.setBool('isLoggedIn', false);

    // Navigate to login screen or any other screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginPage(),
      ),
    );
  }
}
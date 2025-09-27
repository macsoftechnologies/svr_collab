import 'package:flutter/material.dart';
import 'package:svr/utils/colors.dart';
import '../home_screen.dart';

class TestSubmissionView extends StatefulWidget
{
  final Map<String, dynamic> response;
  const TestSubmissionView({super.key, required this.response});

  @override
  State<StatefulWidget> createState() => _TestSubmissionView();
}
// {status: 200, message: Exam Updated Successfully., examId: true, numberofquestions: 120, attempts: 1, correctanswers: 0, wronganswers: 1}
class _TestSubmissionView extends State<TestSubmissionView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset("assets/SVR Logo.png",width: 200,),
              const SizedBox(height: 10,),
              const Text("Test Name",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(50))
                ),
                padding: const EdgeInsets.all(20),
                child: Icon(Icons.done_outline,size: 100,color: whiteColor,),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.4,
                    height: MediaQuery.of(context).size.height*0.15,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Number of Questions",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        Text("Attempts",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        Text("Correct Answers",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        Text("Wrong Answers",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.4,
                    height: MediaQuery.of(context).size.height*0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Text("${widget.response["numberofquestions"]}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                       // print("${widget.response["numberofquestions"]}");
                        Text("${widget.response["attempts"]}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        Text("${widget.response["correctanswers"]}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        Text("${widget.response["wronganswers"]}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              const Text("Exam Updated Successfully.",style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
              InkWell(
                onTap: (){
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute (
                      builder: (BuildContext context) => const HomeScreen(),
                    ),
                    ModalRoute.withName('/'),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: primaryColor
                  ),
                  child: Text("CONTINUE",style: TextStyle(color: whiteColor,fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
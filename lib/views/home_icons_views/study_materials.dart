import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svr/models/home_icons_models/materials_model.dart';
import 'package:svr/view_models/home_icons_view_models/materials_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/colors.dart';

class StudyMaterials extends StatefulWidget
{
  final String subjectId;
  const StudyMaterials({super.key, required this.subjectId});

  @override
  State<StatefulWidget> createState() => _StudyMaterials();

}

class _StudyMaterials extends State<StudyMaterials>
{
  @override
  void initState() {
    Provider.of<MaterialsViewModel>(context, listen: false).fetchMaterials(widget.subjectId,context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Subject Materials"),
      ),
      body: Consumer<MaterialsViewModel>(builder: (context, viewModel, child) {
        if (!viewModel.fetchingData && viewModel.materialsInfo.isEmpty) {
          Provider.of<MaterialsViewModel>(context, listen: false).fetchMaterials(widget.subjectId,context);
          return const Center(child: Text("empty"),);
        }
        if (viewModel.fetchingData) {
          // While data is being fetched
          return const LinearProgressIndicator();
        } else {
          // If data is successfully fetched
          List<MaterialsModel> materials = viewModel.materialsInfo;
          return Column(
            children: [
              Flexible(
                child: ListView.builder(
                    itemCount: materials.length,
                    itemBuilder: (BuildContext context,int index){
                      return Card(
                          child: InkWell(
                              onTap: (){
                                _launchURL(materials[index].pdfLink);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // subjects[index].subjectImage != "" ? Image.network("${subjects[index].subjectImage}") :
                                    const Icon(Icons.picture_as_pdf,size: 30,),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.8,
                                      child: Text("${materials[index].pdfName}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                    )
                                  ],
                                ),
                              )
                          )
                      );
                    }
                ),
              )
            ],
          );
        }
      }),
    );
  }

  _launchURL(pdfFile) async {
    final url = '$pdfFile';
    await launch(url);
  }
}
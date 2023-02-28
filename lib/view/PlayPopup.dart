import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist/service/PlaypopupController.dart';

import '../control/Custom.dart';
import '../control/PlaylistMain.dart';
import '../service/PlayListController.dart';




class PlayPopup extends StatefulWidget {
  const PlayPopup({Key? key}) : super(key: key);

  @override
  State<PlayPopup> createState() => _PlayPopupState();
}

PlayListController playListController = Get.find();

bool _play = false;

class _PlayPopupState extends State<PlayPopup> {

  PlaypopupController playpopupController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 5, left: 10, right: 10,
        child: Container(
          alignment: Alignment.center,
          width: 360, height: 80,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.deepPurple[200],),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // StreamBuilder<Playing?>(
                //     stream: assetsAudioPlayer.current,
                //     builder: (context, playing) {
                //       if (playing.data != null) {
                //         final myAudio = find(
                //             audios, playing.data!.audio.assetAudioPath);
                //         print(playing.data!.audio.assetAudioPath);
                //         return Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Neumorphic(
                //             style: NeumorphicStyle(
                //               depth: 8,
                //               surfaceIntensity: 1,
                //               shape: NeumorphicShape.concave,
                //               boxShape: NeumorphicBoxShape.circle(),
                //             ),
                //             child: myAudio.metas.image?.path == null
                //                 ? const SizedBox()
                //                 : myAudio.metas.image?.type ==
                //                 ImageType.network
                //                 ? Image.network(
                //               myAudio.metas.image!.path,
                //               height: 150,
                //               width: 150,
                //               fit: BoxFit.contain,
                //             )
                //                 : Image.asset(
                //               myAudio.metas.image!.path,
                //               height: 150,
                //               width: 150,
                //               fit: BoxFit.contain,
                //             ),
                //           ),
                //         );
                //       }
                //       return SizedBox.shrink();
                //     }),
                Container(
                  //앨범표지
                  width: 70, height: 70, padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Obx(()=> Image.network('${playpopupController.popupImage}', width: 100, height: 100, fit: BoxFit.contain,),),
                ),
                Container(
                  width: 100, height: 65, padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        //노래제목
                        padding: const EdgeInsets.all(5.0),
                        child: Obx(()=> Text('${playpopupController.popupTitle}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                      ),
                      Padding(
                        //가수이름
                        padding: const EdgeInsets.all(5.0),
                        child: Obx(()=> Text('${playpopupController.popupName}')),
                      ),
                    ],
                  ),
                ),
                IconButton(onPressed: (){
                  assetsAudioPlayer.previous(keepLoopMode: true);
                }, icon: Icon(Icons.skip_previous, size: 35, color: Colors.white),padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),

                Obx(()=> playpopupController.isPlay.value?
                    IconButton(onPressed: (){
                      playpopupController.setIsPlay = false;
                      assetsAudioPlayer.pause();
                      custom.updatePlayListPlay(custom.playlistPoPKey, false).then((value) => {
                        playListController.updateIsPlayModel(custom.playlistPoPIndex, false),
                        playListController.playList.refresh(),});

                    }, icon: Icon(Icons.pause, color: Colors.white, size: 30)) :
                IconButton(
                  onPressed: () async{
                    playpopupController.setIsPlay = true;
                    assetsAudioPlayer.play();
                    custom.updatePlayListPlay(custom.playlistPoPKey, true).then((value) => {
                      playListController.updateIsPlayModel(custom.playlistPoPIndex, true),
                      playListController.playList.refresh(),});
                  },
                  icon: Icon(Icons.play_arrow, size: 30, color: Colors.white,),
                )),

                // IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow, size: 35,),padding: EdgeInsets.fromLTRB(0, 0, 0, 1),),
                IconButton(onPressed: (){
                  assetsAudioPlayer.next();
                }, icon: Icon(Icons.skip_next, size: 35, color: Colors.white),padding: EdgeInsets.fromLTRB(0, 0, 0, 0),),

                IconButton(
                  onPressed: () async{
                    setState(() {
                      _play = !_play;
                      _play?
                      assetsAudioPlayer.setLoopMode(LoopMode.single) : assetsAudioPlayer.loopMode.listen((loopMode){});
                    });
                  },
                  icon: _play ? Icon(Icons.repeat_one, color: Colors.white) : Icon(Icons.repeat,color: Colors.white),padding: EdgeInsets.fromLTRB(0, 0, 10, 0)
                ),
                // IconButton(onPressed: (){
                //   assetsAudioPlayer.toggleLoop();
                // }, icon: Icon(Icons.repeat,),padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
              ],
            ),
              // Container(
              //   //재생바
              //   width: 350,height: 5, //color: Colors.deepPurple,
              //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.deepPurple,),
              // )
            ],
          ),
        ));
  }
}

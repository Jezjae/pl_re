//음원추가 페이지
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../control/Custom.dart';
import '../control/PlaylistMain.dart';
import 'Music.dart';

class musicItems extends StatefulWidget {
  final String pLkey;
  const musicItems({super.key, required this.pLkey});

  @override
  State<musicItems> createState() => musicItemsState();
}



class musicItemsState extends State<musicItems> {
  @override
  Widget build(BuildContext context) {
    // MusicState? parent = context.findAncestorStateOfType<MusicState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, color: Colors.black87,),),
        title: Center(
            child: Text('음원 추가', style: TextStyle(color: Colors.black87, fontSize: 15))
        ),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: Custom().getMusicJSONData(), //전체 곡정보 불러오기기
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                      ));
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                      ));
                    default:
                      return
                        //스냅샷 길이 유무
                        snapshot.data.length == 0?
                        SizedBox.shrink() //없으면 빈화면
                            :
                        Column( //있으면 리스트뷰 만들기
                          children: [
                            Container(
                              width: 450,
                              height: 635,
                              padding: const EdgeInsets.all(20),
                              child: buildItemList(snapshot: snapshot),
                            ),

                            TextButton(onPressed: (){
                                //데이터 업데이트 후 뒤로가기
                                Custom().songUpdateDoc(widget.pLkey, songList).then((value) => {
                                  parent?.setState(() {
                                    playList = getMyMusic(widget.pLkey);
                                    Navigator.of(context).pop();
                                  }),
                                });
                              }, child: Text('플레이리스트에 추가하기')),
                          ],
                        );
                  }
                }
            ),
          ],
        ),
      ),
    );
  }


  //전체음원리스트 아이템 하나씩 넣기
   buildItemList({required AsyncSnapshot<dynamic> snapshot}) {
    List<bool> _play = [];
    for(int i=0;i<snapshot.data.length;i++){
      _play.add(false);
    }
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              InkWell(
                  child: makeMusicList(snapshot: snapshot, index: index),
                  onTap: ()=>{
                    playpopupController.setIsPlay = true,
                    playpopupController.setIsPopup = true,
                    playpopupController.setPopupImage = snapshot.data[index]["image"],
                    playpopupController.setPopupTitle = snapshot.data[index]["title"],
                    playpopupController.setPopupName = snapshot.data[index]["name"]!,
                    assetsAudioPlayer.open(
                      Audio(snapshot.data[index]["path"]),
                    )
                  },),
            ],
          );
        });
  }
}



//음원 체크박스 하나하나 디자인
class makeMusicList extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final int index;
  const makeMusicList({super.key, required this.snapshot, required this.index});

  @override
  State<makeMusicList> createState() => _makeMusicListState();
}

class _makeMusicListState extends State<makeMusicList> {

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 450, height: 150,
          child: Row(
            children: [
              // 앨범 표지
              Image.network(widget.snapshot.data[widget.index]["image"], width: 100, height: 100, fit: BoxFit.contain,),
              Container(
                width: 190, height: 150, padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              //노래 제목
                              padding: const EdgeInsets.all(5.0),
                              child: Text(widget.snapshot.data[widget.index]["title"]),
                    ),
                    Padding(
                      //가수 이름
                      padding: const EdgeInsets.all(5.0),
                      child: Text(widget.snapshot.data[widget.index]["name"]),
                    ),
                  ],
                ),
              ),

              //체크박스
              Checkbox(
                  value: isChecked,
                  onChanged: (value){
                    if(value == true){
                      //음악추가
                      dynamic addMusic = widget.snapshot.data[widget.index]["id"];
                      songList.add(addMusic);
                    }
                    else
                    {
                      //음악 삭제
                      dynamic addMusic = widget.snapshot.data[widget.index]["id"];
                      songList.remove(addMusic);
                    }
                    setState(() {
                      isChecked = value!;
                    });
                  })
            ],
          ),
        ),

        Divider(
          color: Colors.black.withOpacity(0.2),
          thickness: 1.0,
        )
      ],
    );
  }


}
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../control/PlaylistMain.dart';
import '../model/MusicItemsModel.dart';
import '../model/PlayListModel.dart';
import '../service/PlayListController.dart';
import '../control/Custom.dart';
import 'Music.dart';
import 'MyPlayList.dart';



class LikePlayList extends StatefulWidget {
  const LikePlayList({Key? key}) : super(key: key);

  @override
  State<LikePlayList> createState() => LikePlayListState();
}

late Future<List<PlayListModel>> playList;

class LikePlayListState extends State<LikePlayList> {

  //get x 사용을 위해 불러오는 작업
  PlayListController playListController = Get.find();

  Future<List<PlayListModel>> getPlayListModel() async {
    final CollectionReference playListCollRef = FirebaseFirestore.instance.collection('playlist');
    List<PlayListModel> resultPlayList = [];
    QuerySnapshot querySnapshot = await playListCollRef.where('IsFav', isEqualTo: true).get();

    querySnapshot.docs.forEach((element) {
      resultPlayList.add(PlayListModel.fromSnapshot(element));
    });
    return resultPlayList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playList = getPlayListModel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: Text('관심목록', style: TextStyle(color: Colors.black87, fontSize: 15))
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: playList,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                      ));
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                      ));
                    default:
                    //다 불러오면 상태변화할 데이터의 주소에 스냅샷 데이터 넣기
                      playListController.setPlayListModel = snapshot.data;
                      return
                        snapshot.data.length == 0?
                        SizedBox.shrink() :
                        Column(
                          children: [
                            Container(
                              width: 450,
                              height: 675,
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Items(snapshot: snapshot, index: index);
                                  }),
                            ),
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
}

class Items extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final int index;
  const Items({super.key, required this.snapshot, required this.index});

  @override
  State<Items> createState() => _ItemsState();

}

class _ItemsState extends State<Items> {

  //get x 사용을 위해 불러오는 작업
  PlayListController playListController = Get.find();

  Future<List<PlayListModel>> getPlayListModel() async {
    final CollectionReference playListCollRef = FirebaseFirestore.instance.collection('playlist');
    List<PlayListModel> resultPlayList = [];
    QuerySnapshot querySnapshot = await playListCollRef.where('IsFav', isEqualTo: true).get();

    querySnapshot.docs.forEach((element) {
      resultPlayList.add(PlayListModel.fromSnapshot(element));
    });
    return resultPlayList;
  }

  bool isColor = false;

  final inputText = TextEditingController();
  String? setTitle;


  List<MusicItemsModel> playlistItems() {
    List<MusicItemsModel> playlistItems = [];
    for(int i = 0; i < widget.snapshot.data[widget.index].musicList.length; i++)
    {
      for(int j = 0; j < Custom.musicData.length; j++)
      {
        if(Custom.musicData[j]['id'] == widget.snapshot.data[widget.index].musicList[i])
        {
          MusicItemsModel musicItemsModel = MusicItemsModel(isPlay: false);
          musicItemsModel.id = Custom.musicData[j]['id'];
          musicItemsModel.image  = Custom.musicData[j]['image'];
          musicItemsModel.path  = Custom.musicData[j]['path'];
          musicItemsModel.title = Custom.musicData[j]['title'];
          musicItemsModel.name = Custom.musicData[j]['name'];
          musicItemsModel.length = Custom.musicData[j]['length'];
          musicItemsModel.isPlay = false;

          //매칭완료된 곡정보까지 들어간 선택곡 정보리스트
          playlistItems.add(musicItemsModel);
        }
      }
    }
    return playlistItems;
  }

  @override

  Widget build(BuildContext context) {
    LikePlayListState? parent = context.findAncestorStateOfType<LikePlayListState>();
    return Column(
      children: [
        InkWell(
          child: Container(
            width: 400, height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  //앨범표지
                  width: 80, height: 80,
                  child: Image.asset('assets/bom.png'),
                ),
                Container(
                  width: 270, height: 100, padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 100, height: 100, padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
                          child: Text(widget.snapshot.data[widget.index].title, style: TextStyle(fontSize: 15),)),


                      Obx(() => playListController.playList.value![widget.index].isPlay?
                      IconButton(onPressed: () async{
                        custom.playlistPoPIndex = widget.index;
                        custom.playlistPoPKey = widget.snapshot.data[widget.index].playListKey;
                        playpopupController.setIsPlay = false; //팝업창의 플레이:퓨즈 로 바꿔주는 것
                        custom.updatePlayListPlay(widget.snapshot.data[widget.index].playListKey, false).then((value) => {
                          playListController.updateIsPlayModel(widget.index, false),
                          assetsAudioPlayer.pause(),
                          playListController.playList.refresh(),});

                      }, icon: Icon(Icons.pause, size: 30,)):
                      IconButton(
                        onPressed: () async{

                          custom.playlistPoPIndex = widget.index;
                          custom.playlistPoPKey = widget.snapshot.data[widget.index].playListKey;
                          playpopupController.setIsPlay = true; //팝업창의 플레이:퓨즈 로 바꿔주는 것
                          playpopupController.setIsPopup = true; // 노래가 재생될 때 팝업창 띄워 주는 것

                          List<MusicItemsModel> playlistItemsPath = playlistItems();
                          //custom.listItems = playlistItemsPath;
                          assetsAudioPlayer.open(
                              Playlist(
                                  audios: [
                                    for(int i =0;i<playlistItemsPath.length;i++)
                                      Audio('${playlistItemsPath[i].path}'),
                                  ]
                              ),
                              loopMode: LoopMode.playlist //loop the full playlist
                          );

                          // print('노래제목알아보고싶어');
                          // print(playlistItemsPath[1].image);
                          playpopupController.setPopupImage = playlistItemsPath[0].image!;
                          playpopupController.setPopupTitle = playlistItemsPath[0].title!;
                          playpopupController.setPopupName = playlistItemsPath[0].name!;

                          custom.updatePlayListPlay(widget.snapshot.data[widget.index].playListKey, true).then((value) => {
                            playListController.updateIsPlayModel(widget.index, true),
                            playListController.playList.refresh(),});

                          //assetsAudioPlayer.playlistPlayAtIndex(i);

                          // playpopupController.isPlay.refresh();
                        },
                        icon: Icon(Icons.play_arrow, size: 30,),
                      ),
                      ),

                      //플레이리스트 좋아요 눌러져있나? 아닌가?
                      Obx(() => playListController.playList.value![widget.index].isFav?

                      //눌러져 있음
                      IconButton(onPressed: (){
                        //데이터베이스에서 데이터 수정 후 데이터담은 리스트에서 수정하고 이 아이콘만 새로고침?
                        custom.updatePlayListFav(widget.snapshot.data[widget.index].playListKey, false).then((value) => {
                          playListController.updateFavPlayModel(widget.index, false),
                          playListController.playList.refresh(),});
                      }, icon: Icon(Icons.favorite, color: Colors.deepPurpleAccent,))
                          : IconButton(onPressed: () {
                        custom.updatePlayListFav(widget.snapshot.data[widget.index].playListKey, true).then((value) => {
                          playListController.updateFavPlayModel(widget.index, true),
                          playListController.playList.refresh(),});
                      }, icon: Icon(Icons.favorite_border, color: Colors.grey,),)),


                      IconButton(onPressed: (){
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            double width = MediaQuery.of(context).size.width;
                            double height = MediaQuery.of(context).size.height;
                            return AlertDialog(
                                backgroundColor: Colors.transparent,
                                contentPadding: EdgeInsets.zero,
                                elevation: 0.0,
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(10.0))),
                                      child: Column(
                                        children: [
                                          TextButton(onPressed: (){
                                            Navigator.of(context).pop();
                                            showDialog(context: context,
                                                barrierDismissible: true,
                                                builder: (BuildContext context){
                                                  return AlertDialog(
                                                    backgroundColor: Colors.white,

                                                    title: Text('플레이리스트 이름을 입력하세요'),
                                                    content: Container(
                                                      width: 200, height: 70, padding: EdgeInsets.all(10),
                                                      child: TextField(
                                                        controller: inputText,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(onPressed: (){
                                                        Navigator.of(context).pop();

                                                        setTitle = inputText.text;

                                                        //정한 이름 데이터베이스에 넣고 초기화
                                                        Custom().updateDocTitle(widget.snapshot.data[widget.index].playListKey, '$setTitle');

                                                        inputText.text = '';

                                                        parent?.setState(() {
                                                          playList = getPlayListModel();
                                                        });

                                                      }, child: Text('확인'))
                                                    ],
                                                  );
                                                });
                                          }, child: Text('제목 수정하기', style: TextStyle(fontSize: 20))),
                                          Divider(),
                                          TextButton(onPressed: (){
                                            Navigator.of(context).pop();
                                            Custom().deleteDoc(widget.snapshot.data[widget.index].playListKey).then((value) =>
                                            {
                                              parent?.setState(() {
                                                playList = getPlayListModel();
                                              })
                                            });

                                          },
                                              child: Text('삭제하기', style: TextStyle(color: Colors.red, fontSize: 20),)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(10.0))),
                                      child: Center(child: TextButton(onPressed: (){Navigator.of(context).pop();},
                                          child: Text('취소', style: TextStyle(fontSize: 20))),),
                                    )
                                  ],
                                ));
                          },
                        );
                      }, icon: Icon(Icons.more_horiz, color: Colors.grey))
                    ],
                  ),
                ),
              ],
            ),
          ),

          onTap: (){
            String pLkey = widget.snapshot.data[widget.index].playListKey;
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => Music(pLkey: pLkey)),
            );
          },
        ),
        Divider(
          color: Colors.black.withOpacity(0.2),
          thickness: 1.0,
        )
      ],
    );
  }


}


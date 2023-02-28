import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../model/MusicItemsModel.dart';



class PlaypopupController{

  RxString popupTitle = RxString('String title');
  RxString popupImage = RxString('String image');
  RxString popupName = RxString('String name');

  RxBool isPlay = RxBool(false);
  RxBool isPopup = RxBool(false);
  RxList<MusicItemsModel> popupPlayList = RxList<MusicItemsModel>();

  set setPopupTitle(String title){
    popupTitle(title);
  }

  set setPopupImage(String image){
    popupImage(image);
  }

  set setPopupName(String name){
    popupName(name);
  }

  set setIsPopup(bool value){
    isPopup(value);
  }
  set setIsPlay(bool value){
    isPlay(value);
  }

  set setPopupPlayListListModel(List<MusicItemsModel> value){
    popupPlayList(value);
  }


  // void updatePlayModel(PlayListModel value, int index){
  //   playList[index] = value;
  // }

  // void updatepopupPlayList(List<MusicItemsModel> value){
  //   popupPlayList(value);
  // }

}
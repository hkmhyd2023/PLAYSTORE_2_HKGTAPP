
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:harekrishnagoldentemple/Home/Ekadashi.dart';
import 'package:harekrishnagoldentemple/RoutePages/JapaPage.dart';
import 'package:harekrishnagoldentemple/Seek_Divine_Blessings/Seva_Detail.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RDetail extends StatefulWidget {
  final DocumentSnapshot document;

  const RDetail({super.key, required this.document});

  @override
  State<RDetail> createState() => _RDetailState();
}

class _RDetailState extends State<RDetail>  {

  late YoutubePlayerController _controller;
  late String imagelive;
    @override
  void initState() {
    super.initState();
loadLiveLink();
  }
  Future<void> loadLiveLink() async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('LDL').doc('LDL').get();

      if (userSnapshot.exists) {
        String link = userSnapshot['Link'];
        setState(() {
          _controller = YoutubePlayerController(
            initialVideoId: link,
          );
          imagelive = userSnapshot['Image'];
        });
      } else {
        print("not found");
      }
    } catch (e) {
      // Handle errors
      print('Error loading user data: $e');
    }
  }
  _redirectToPageTwo(String route, String dropdown_item) async {
    if (route == "Ekadashi") {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Upcoming-Event')
          .doc('mP1nsNtfs4wDbLIcaATu')
          .get();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EkadashiDetail(
                    image_url: document['Main-Image'],
                    title: document['Title'],
                    date: document['Date'],
                    description: document['Description'],
                  )));
    } else if (route == "Japa") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => JapaPage()));
    } else if (route == "Live") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
              ));
        },
      );
    } else if (route == "Seva") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SevaDetail(dropdown_title: dropdown_item)));
    }
  }
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken().then((token) {
      print(token);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      FirebaseFirestore.instance.collection('Notifications').doc().set({
    'Title': '${message.data['Title']}',
    'Description': '${message.data['Description']}',
    'Image': '${message.data['Image']}'
    // add more fields as needed
  });
      _redirectToPageTwo(message.data['Route'], message.data['Dropdown_Item']);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _redirectToPageTwo(message.data['Route'], message.data['Dropdown_Item']);
    });
    return Scaffold(
      appBar: AppBar(title: Text(widget.document['Title']), backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            SizedBox(height: 20),            


            //Image
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [
                  CachedNetworkImage(
                                
                                imageUrl: widget.document['Image'],
  imageBuilder: (context, imageProvider) => Container(
height: 250,
width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      
      image: DecorationImage(
        
        image: imageProvider, fit: BoxFit.cover, ),
    ),
  ),
                                
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ),
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                              ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      widget.document['Title'],
                      style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            //Food information
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                color: Colors.orange.shade200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network('https://cdn-icons-png.flaticon.com/512/1912/1912723.png', height: 35, width: 35, fit: BoxFit.cover),
                          SizedBox(height: 4),
                          Text('${widget.document['Calories']}', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                          Text('Calories', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12, color: Colors.black)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network('https://www.freepnglogos.com/uploads/salt-png/determination-sodium-and-salt-content-food-samples-10.png', height: 35, width: 35, fit: BoxFit.cover),
                          SizedBox(height: 4),
                          Text(widget.document['Salt'], style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                          Text('Salt', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12, color: Colors.black)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network('https://www.pngall.com/wp-content/uploads/2016/07/Sugar-Free-Download-PNG.png', height: 35, width: 35, fit: BoxFit.cover),
                          SizedBox(height: 4),
                          Text(widget.document['Sugar'], style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                          Text('Sugar', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12, color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            //Ingredients title line
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ingredients', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
              ],
            ),

            SizedBox(height: 16),

Column(children: [
                      StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("RCDetail")
                  .doc(widget.document.id)
                  .collection("Ingredients")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Text('No data found');
                }
                return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: (1 / 1.5), mainAxisSpacing: 16, crossAxisSpacing: 16),
        physics:  NeverScrollableScrollPhysics(),
        itemCount: snapshot.data!.size,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
                                final DocumentSnapshot document =
                          snapshot.data!.docs[index];
          return ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: InkWell(
                    child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width / 3 - 16,
                      color: Colors.orange.shade200,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                                
                                imageUrl: document['Image'],
  imageBuilder: (context, imageProvider) => Container(
    height: 80.0,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      image: DecorationImage(
        
        image: imageProvider, fit: BoxFit.cover,),
    ),
  ),
                                
                                placeholder: (context, url) =>
                                    Image.asset("assets/loading-gif.gif", height: 80, width: MediaQuery.of(context).size.width,),
                              ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(document['Title'], style: TextStyle(fontSize: 12, color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
          );
              },
            ),
          ]),

            SizedBox(height: 16),

            Align(
              alignment: Alignment.centerLeft,
              child: Text('Directions', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
            ),

            SizedBox(height: 16),
            
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("RCDetail")
                  .doc(widget.document.id)
                  .collection('Directions')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Text('No data found');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  physics:const  NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot document =
                        snapshot.data!.docs[index];
                    return Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.orange.shade200,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        child: Row(
                          children: [
                            Text((index + 1).toString(), style: TextStyle(color: Colors.orange.shade900, fontSize: 20, fontWeight: FontWeight.w700)),
                            SizedBox(width: 8),
                            Expanded(child: Text(document['Text'], style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500))),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                  },
                );
              },
            ),

            SizedBox(height: 8),

          ],
        ),
      ),
    );

  }
}
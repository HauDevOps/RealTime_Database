import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.app}) : super(key: key);

  final FirebaseApp? app;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final referenceDatabase = FirebaseDatabase.instance;
  TextEditingController textController = TextEditingController();
  final movieName = 'Movie';

  DatabaseReference? _moviesRef;

  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    // TODO: implement initState
    super.initState();
    _moviesRef = database.reference().child('Movie');
  }

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();

    return Scaffold(
      appBar: AppBar(
        title: Text('Realtime Database'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Container(
          color: Colors.greenAccent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Text(
                movieName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: textController,
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .child('Movie')
                      .push()
                      .child(movieName)
                      .set(textController.text)
                      .asStream();
                  textController.clear();
                },
                child: Text('Save Movie'),
              ),
              Flexible(
                  child: new FirebaseAnimatedList(
                    shrinkWrap: true,
                      query: _moviesRef!,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return ListTile(
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                _moviesRef!.child(snapshot.key!).remove(),
                          ),
                          title: Text(snapshot.value['Movie']),
                        );
                      }))
            ],
          ),
        ),
      )),
    );
  }
}

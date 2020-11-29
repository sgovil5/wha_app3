import 'package:flutter/material.dart';

class PractitionerPreview extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String modalityText;
  final Key key;

  PractitionerPreview(this.name, this.imageUrl, this.modalityText, {this.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      child: Column(
        children: [
          Divider(
            thickness: 2,
            color: Colors.white,
            height: 0,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(0),
                width: 100,
                height: 100,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.all(15),
                        child: Text(
                          modalityText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

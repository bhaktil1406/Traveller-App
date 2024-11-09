// import 'package:example/example_candidate_model.dart';
// import 'package:example/example_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:tourist_app/pages/Homepage2.dart';

var primaryColor = const Color(0xFF1EFEBB);
var secondaryColor = const Color(0xFF02050A);
var ternaryColor = const Color(0xFF1B1E23);

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Categories(),
    ),
  );
}

class Categories extends StatefulWidget {
  const Categories({
    super.key,
  });

  @override
  State<Categories> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<Categories> {
  final CardSwiperController controller = CardSwiperController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final cards = candidates.map(ExampleCard.new).toList();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: CardSwiper(
                controller: controller,
                cardsCount: cards.length,
                onSwipe: _onSwipe,
                onUndo: _onUndo,
                numberOfCardsDisplayed: 3,
                backCardOffset: const Offset(40, 40),
                padding: const EdgeInsets.all(24.0),
                cardBuilder: (
                  context,
                  index,
                  horizontalThresholdPercentage,
                  verticalThresholdPercentage,
                ) =>
                    cards[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(primaryColor)),
                      child: Text(
                        "Continue To HomePage",
                        style: TextStyle(
                            backgroundColor: primaryColor, color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (e) => const Homepage2()));
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (direction == CardSwiperDirection.right) {
      _saveSwipeToFirebase(previousIndex);
    }

    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    return true;
  }

  void _saveSwipeToFirebase(int index) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      DocumentReference userDocRef =
          firestore.collection('user').doc(currentUser.uid);
      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        List<dynamic> currentLiked = userDoc.get("categories");
        if (!currentLiked.contains(index)) {
          await userDocRef.update({
            "categories": FieldValue.arrayUnion([index])
          });
        }
        // print(userDocRef);
      }

      // return userDocRef;
    } else {
      throw Exception('No user is currently signed in.');
    }
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }
}

class ExampleCandidateModel {
  final String name;
  final String job;
  final String city;
  // final List<Color> color;
  final String img;

  ExampleCandidateModel({
    required this.name,
    required this.job,
    required this.city,
    required this.img,
  });
}

final List<ExampleCandidateModel> candidates = [
  ExampleCandidateModel(
    name: 'Hikking',
    job:
        'Hiking is an outdoor activity of walking scenic trails for exploration and fitness.',
    city: '',
    img: "Hiking.jpeg",
  ),
  ExampleCandidateModel(
    name: 'Religious Places',
    job:
        'Religious places are sacred sites for worship, reflection, and spiritual connection.',
    city: '',
    img: "religious.jpeg",
  ),
  ExampleCandidateModel(
    name: 'Beaches',
    job:
        'Beaches are sandy shores where land meets water, perfect for relaxation.',
    city: '',
    img: "beach.jpeg",
  ),
  ExampleCandidateModel(
    name: 'Mountains',
    job:
        'Mountains are tall, rugged landforms offering stunning views and biodiversity.',
    city: '',
    img: "mountain.jpeg",
  ),
  ExampleCandidateModel(
    name: 'Historical Places',
    job:
        'Historical places are landmarks preserving cultural heritage, history, and architecture.',
    city: '',
    img: "historical.jpeg",
  ),
  ExampleCandidateModel(
    name: 'Museums',
    job:
        'A museum is a place where artifacts and exhibits showcase history, art, and culture.',
    city: '',
    img: "museum.webp",
  ),
  ExampleCandidateModel(
    name: 'National Park',
    job:
        'A national park is a protected area preserving natural beauty and wildlife.',
    city: '',
    img: "nationalpark.webp",
  ),
  ExampleCandidateModel(
    name: 'Wildlife',
    job:
        'Wildlife encompasses diverse animal species living freely in natural habitats.',
    city: '',
    img: "wildlife.jpeg",
  ),
];

class ExampleCard extends StatelessWidget {
  final ExampleCandidateModel candidate;

  const ExampleCard(
    this.candidate, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: ternaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              width: double.infinity,
              child: Image.asset(
                'assets/${candidate.img}',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  candidate.name,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  candidate.job,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  candidate.city,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

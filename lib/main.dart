import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Pokedex homepage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _pokemonName = "Unknown";
  final picker = ImagePicker();

  Map<int, String> indexToClass = {
    0: 'Abra',
    1: 'Aerodactyl',
    2: 'Alakazam',
    3: 'Arbok',
    4: 'Arcanine',
    5: 'Articuno',
    6: 'Beedrill',
    7: 'Bellsprout',
    8: 'Blastoise',
    9: 'Bulbasaur',
    10: 'Butterfree',
    11: 'Caterpie',
    12: 'Chansey',
    13: 'Charizard',
    14: 'Charmander',
    15: 'Charmeleon',
    16: 'Clefable',
    17: 'Clefairy',
    18: 'Cloyster',
    19: 'Cubone',
    20: 'Dewgong',
    21: 'Diglett',
    22: 'Ditto',
    23: 'Dodrio',
    24: 'Doduo',
    25: 'Dragonair',
    26: 'Dragonite',
    27: 'Dratini',
    28: 'Drowzee',
    29: 'Dugtrio',
    30: 'Eevee',
    31: 'Ekans',
    32: 'Electabuzz',
    33: 'Electrode',
    34: 'Exeggcute',
    35: 'Exeggutor',
    36: 'Farfetchd',
    37: 'Fearow',
    38: 'Flareon',
    39: 'Gastly',
    40: 'Gengar',
    41: 'Geodude',
    42: 'Gloom',
    43: 'Golbat',
    44: 'Goldeen',
    45: 'Golduck',
    46: 'Golem',
    47: 'Graveler',
    48: 'Grimer',
    49: 'Growlithe',
    50: 'Gyarados',
    51: 'Haunter',
    52: 'Hitmonchan',
    53: 'Hitmonlee',
    54: 'Horsea',
    55: 'Hypno',
    56: 'Ivysaur',
    57: 'Jigglypuff',
    58: 'Jolteon',
    59: 'Jynx',
    60: 'Kabuto',
    61: 'Kabutops',
    62: 'Kadabra',
    63: 'Kakuna',
    64: 'Kangaskhan',
    65: 'Kingler',
    66: 'Koffing',
    67: 'Krabby',
    68: 'Lapras',
    69: 'Lickitung',
    70: 'Machamp',
    71: 'Machoke',
    72: 'Machop',
    73: 'Magikarp',
    74: 'Magmar',
    75: 'Magnemite',
    76: 'Magneton',
    77: 'Mankey',
    78: 'Marowak',
    79: 'Meowth',
    80: 'Metapod',
    81: 'Mew',
    82: 'Mewtwo',
    83: 'Moltres',
    84: 'MrMime',
    85: 'Muk',
    86: 'Nidoking',
    87: 'Nidoqueen',
    88: 'Nidorina',
    89: 'Nidorino',
    90: 'Ninetales',
    91: 'Oddish',
    92: 'Omanyte',
    93: 'Omastar',
    94: 'Onix',
    95: 'Paras',
    96: 'Parasect',
    97: 'Persian',
    98: 'Pidgeot',
    99: 'Pidgeotto',
    100: 'Pidgey',
    101: 'Pikachu',
    102: 'Pinsir',
    103: 'Poliwag',
    104: 'Poliwhirl',
    105: 'Poliwrath',
    106: 'Ponyta',
    107: 'Porygon',
    108: 'Primeape',
    109: 'Psyduck',
    110: 'Raichu',
    111: 'Rapidash',
    112: 'Raticate',
    113: 'Rattata',
    114: 'Rhydon',
    115: 'Rhyhorn',
    116: 'Sandshrew',
    117: 'Sandslash',
    118: 'Scyther',
    119: 'Seadra',
    120: 'Seaking',
    121: 'Seel',
    122: 'Shellder',
    123: 'Slowbro',
    124: 'Slowpoke',
    125: 'Snorlax',
    126: 'Spearow',
    127: 'Squirtle',
    128: 'Starmie',
    129: 'Staryu',
    130: 'Tangela',
    131: 'Tauros',
    132: 'Tentacool',
    133: 'Tentacruel',
    134: 'Vaporeon',
    135: 'Venomoth',
    136: 'Venonat',
    137: 'Venusaur',
    138: 'Victreebel',
    139: 'Vileplume',
    140: 'Voltorb',
    141: 'Vulpix',
    142: 'Wartortle',
    143: 'Weedle',
    144: 'Weepinbell',
    145: 'Weezing',
    146: 'Wigglytuff',
    147: 'Zapdos',
    148: 'Zubat'
  };

  Future<List<int>> imageToByteListUint8(
      File imageFile, int width, int height) async {
    Uint8List imageBytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);
    img.Image resizedImage =
        img.copyResize(image!, width: width, height: height);

    var convertedBytes = img.encodeJpg(resizedImage, quality: 100);

    return convertedBytes;
  }

  Future<void> _takePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final Uint8List imageBytes = await imageFile.readAsBytes();

      var reshapedImageBytes = List.generate(
          150,
          (h) => List.generate(
              150,
              (w) => List.generate(
                  3, (c) => imageBytes[h * 150 * 3 + w * 3 + c])));

      final response = await http.post(
        Uri.parse(
            'https://pokemon-model-service-arturobarrios616.cloud.okteto.net/v1/models/pokemon-model:predict'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'instances': [
            {
              'my_input': reshapedImageBytes,
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        List<dynamic> predictions = jsonResponse['predictions'][0];
        List<double> doublePredictions =
            predictions.cast<double>(); // Convierte la lista a double.
        double maxValue = doublePredictions.reduce(max);
        int highestIndex = doublePredictions.indexOf(maxValue);
        if (indexToClass.containsKey(highestIndex)) {
          String predictedPokemon = indexToClass[highestIndex] as String;
          setState(() {
            _pokemonName = predictedPokemon;
          });
        } else {
          print('Highest index not found in indexToClass map: $highestIndex');
        }
      } else {
        print("Response body: ${response.body} ");
        print('Failed to predict pokemon. Status code: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'The Pokemon is:',
            ),
            Text(
              _pokemonName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        tooltip: 'Take Picture',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

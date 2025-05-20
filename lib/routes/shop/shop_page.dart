import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:tiny_satoshi/utils/custom_sprite_animation_widget.dart';
import 'package:tiny_satoshi/utils/player_sprite_sheet.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final List<CharacterItem> characters = [
    CharacterItem(
      name: 'Tiny Satoshi',
      description: 'Your default character',
      price: 0,
      sprite: PlayerSpriteSheet.idleRight,
      isLocked: false,
    ),
    CharacterItem(
      name: 'Hal Finney',
      description: 'First Bitcoin transaction recipient',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Hal Finney sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Nick Szabo',
      description: 'Cryptographer and creator of Bit Gold',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Nick Szabo sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Adam Back',
      description: 'Creator of Hashcash and CEO of Blockstream',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Adam Back sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Gavin Andresen',
      description: 'Early Bitcoin Core developer',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Gavin sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Andreas M. Antonopoulos',
      description: 'Bitcoin educator and author',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Andreas sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Pieter Wuille',
      description: 'Bitcoin Core developer, SegWit creator',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Pieter sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Luke Dashjr',
      description: 'Bitcoin Core developer, mining expert',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Luke sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Michael Saylor',
      description: 'Bitcoin advocate, MicroStrategy CEO',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Saylor sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Jack Dorsey',
      description: 'Bitcoin advocate, Block CEO',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Jack sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Ben Arc',
      description: 'Everything Lightning and LNBits',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Ben sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Supertestnet',
      description: 'Creator of great new Bitcoin tools',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Supertestnet sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Tadge Dryja',
      description: 'Lightning Network co-creator',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Tadge sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Jeremy Rubin',
      description: 'Bitcoin Core developer, OP_CTV creator',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Jeremy sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Ruben Somsen',
      description:
          'Bitcoin researcher and protocol designer renowned for pioneering Silent Payments (BIP 352)',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Ruben sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Jimmy Song',
      description:
          'Bitcoin educator, developer, and author of "Programming Bitcoin"',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Jimmy sprite
      isLocked: true,
    ),
    CharacterItem(
      name: 'Cypherpunk',
      description: 'Early Bitcoin contributor',
      price: 10000,
      sprite: PlayerSpriteSheet.idleRight, // Replace with Cypherpunk sprite
      isLocked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bitcoin Legends',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF2D2B56),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Unlock Bitcoin Legends',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final character = characters[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CharacterCard(
                      character: character,
                      onPurchase: () => _handlePurchase(character),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePurchase(CharacterItem character) {
    if (!character.isLocked) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2D2B56),
            title: Text(
              'Coming Soon!',
              style: const TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.construction, color: Colors.amber, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Unlocking ${character.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    character.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Character unlocking feature is coming soon!\n\nYou\'ll be able to unlock Bitcoin legends by sending sats to a special address.',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Got it!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}

class CharacterCard extends StatelessWidget {
  final CharacterItem character;
  final VoidCallback onPurchase;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2D2B56).withOpacity(0.8),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (character.isLocked)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                    else
                      CustomSpriteAnimationWidget(animation: character.sprite),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                character.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                character.description,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              if (character.price > 0)
                Text(
                  '${character.price} sats',
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: character.isLocked ? onPurchase : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledBackgroundColor: Colors.grey,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    character.isLocked ? 'Unlock' : 'Selected',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CharacterItem {
  final String name;
  final String description;
  final int price;
  final Future<SpriteAnimation> sprite;
  final bool isLocked;

  CharacterItem({
    required this.name,
    required this.description,
    required this.price,
    required this.sprite,
    required this.isLocked,
  });
}

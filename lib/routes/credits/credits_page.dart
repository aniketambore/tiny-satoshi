import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Credits',
          style: TextStyle(color: Colors.white, fontSize: 24),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('Game Engine', [
                _buildCreditItem(
                  'Bonfire',
                  '2D Game Engine for Flutter',
                  'https://bonfire-engine.github.io/',
                  Icons.sports_esports,
                ),
                _buildCreditItem(
                  'BDK',
                  'Bitcoin Development Kit',
                  'https://bitcoindevkit.org/',
                  Icons.account_balance_wallet,
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection('Game Assets', [
                _buildCreditItem(
                  'Dungeon Tileset II',
                  'Game Tiles & Sprites',
                  'https://0x72.itch.io/dungeontileset-ii',
                  Icons.image,
                ),
                _buildCreditItem(
                  'Music Loop Bundle',
                  'Background Music',
                  'https://tallbeard.itch.io/music-loop-bundle',
                  Icons.music_note,
                ),
              ]),
              _buildSection('Game Creator', [
                _buildCreditItem(
                  'Anipy',
                  'Software Engineer',
                  'https://twitter.com/Anipy1',
                  Icons.person,
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection('Special Thanks', [
                _buildCreditItem(
                  'Satoshi Nakamoto',
                  'Creator of Bitcoin',
                  'https://bitcoin.org/bitcoin.pdf',
                  Icons.favorite,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }

  Widget _buildCreditItem(
    String title,
    String subtitle,
    String url,
    IconData icon,
  ) {
    return Card(
      color: const Color(0xFF2D2B56).withOpacity(0.8),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.link, color: Colors.white),
        onTap: () => _launchURL(url),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(const IslamkeJaniOManiApp());

const navy = Color(0xFF123C56);
const teal = Color(0xFF147D78);
const gold = Color(0xFFD8B56D);

class IslamkeJaniOManiApp extends StatelessWidget {
  const IslamkeJaniOManiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ইসলামকে জানি ও মানি',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: teal, primary: navy, secondary: gold),
        scaffoldBackgroundColor: const Color(0xFFF6F8F7),
        appBarTheme: const AppBarTheme(backgroundColor: navy, foregroundColor: Colors.white),
        fontFamily: 'NotoSansBengali',
      ),
      home: const HomePage(),
    );
  }
}

class Topic {
  final String title, icon, description;
  const Topic(this.title, this.icon, this.description);
}

const topics = <Topic>[
  Topic('ঈমান ও আকিদা', '☪️', 'তাওহিদ, ঈমানের স্তম্ভ, ফেরেশতা, তাকদির ও ইহসান'),
  Topic('কুরআন ও তাফসির', '📖', 'আয়াত, বাংলা অর্থ, সূরা-আয়াত নম্বর ও তাফসিরের সূত্র'),
  Topic('হাদিস', '📜', 'হাদিসের মূল পাঠ, অনুবাদ, গ্রন্থ, নম্বর ও মান'),
  Topic('নামাজ', '🕌', 'ওজু, পাঁচ ওয়াক্ত, জামাত, জুমা ও বিশেষ নামাজ'),
  Topic('রোজা', '🌙', 'রমজান, রোজার বিধান, কাযা ও নফল রোজা'),
  Topic('যাকাত ও সদকা', '🤲', 'যাকাতের বিধান, হিসাব ও দানের আদব'),
  Topic('হজ ও উমরাহ', '🕋', 'ইহরাম, মানাসিক, বিধান ও প্রস্তুতি'),
  Topic('দোয়া ও যিকির', '📿', 'দৈনন্দিন দোয়া, যিকির, আরবি, উচ্চারণ ও অর্থ'),
  Topic('তাওবা ও গুনাহ', '💚', 'তাওবার শর্ত, ক্ষমা প্রার্থনা ও গুনাহ থেকে বাঁচা'),
  Topic('মৃত্যু ও কবর', '⚰️', 'মৃত্যু, জানাজা, বারযাখ ও কবরসংক্রান্ত দলিল'),
  Topic('কিয়ামত ও আখিরাত', '🌅', 'পুনরুত্থান, হিসাব, মিজান ও সিরাত'),
  Topic('জান্নাত ও জাহান্নাম', '✨', 'কুরআন-হাদিসে বর্ণিত আখিরাতের বিবরণ'),
  Topic('রাসুলুল্লাহ ﷺ-এর জীবন', '🌟', 'সিরাত, শিক্ষা, চরিত্র ও সুন্নাহ'),
  Topic('সাহাবিদের জীবন', '👥', 'সাহাবিদের জীবনী ও শিক্ষণীয় ঘটনা'),
  Topic('আখলাক ও চরিত্র', '❤️', 'সত্যবাদিতা, ধৈর্য, আমানত ও উত্তম আচরণ'),
  Topic('পরিবার ও বিবাহ', '🏡', 'দাম্পত্য, সন্তান, পিতা-মাতার অধিকার'),
  Topic('হালাল ও হারাম', '⚖️', 'খাদ্য, উপার্জন ও দৈনন্দিন বিধান'),
  Topic('ব্যবসা-বাণিজ্য', '💼', 'লেনদেন, ঋণ, সুদ ও ব্যবসায়িক নৈতিকতা'),
  Topic('মানুষের অধিকার', '🤝', 'প্রতিবেশী, আত্মীয়, সমাজ ও ন্যায্যতা'),
  Topic('দৈনন্দিন জীবনে ইসলাম', '🌿', 'পরিচ্ছন্নতা, সময়, অভ্যাস ও বাস্তব জীবনের শিক্ষা'),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  String query = '';
  @override
  Widget build(BuildContext context) {
    final filtered = topics.where((t) => t.title.contains(query) || t.description.contains(query)).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ইসলামকে জানি ও মানি', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          Text('কুরআন ও সুন্নাহর আলোকে ইসলামের জ্ঞান', style: TextStyle(fontSize: 11)),
        ]),
        actions: [IconButton(onPressed: () => showAboutDialog(context: context, applicationName: 'ইসলামকে জানি ও মানি', applicationVersion: '0.1.0', children: const [Text('বিষয়ভিত্তিক ইসলামিক জ্ঞানভান্ডারের প্রাথমিক সংস্করণ। প্রকাশের আগে দলিল ও অনুবাদ যাচাই করা প্রয়োজন।')]), icon: const Icon(Icons.info_outline))],
      ),
      body: tab == 0 ? _home(filtered) : tab == 1 ? _quranPage() : tab == 2 ? _hadithPage() : _savedPage(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'হোম'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'কুরআন'),
          NavigationDestination(icon: Icon(Icons.auto_stories_outlined), label: 'হাদিস'),
          NavigationDestination(icon: Icon(Icons.bookmark_border), label: 'সংরক্ষিত'),
        ],
      ),
    );
  }

  Widget _home(List<Topic> filtered) => ListView(padding: const EdgeInsets.all(16), children: [
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [navy, teal]), borderRadius: BorderRadius.circular(22)),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white, fontSize: 23)),
        SizedBox(height: 12), Text('জানুন, বুঝুন, আমল করুন', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
        SizedBox(height: 6), Text('কুরআন, নির্ভরযোগ্য হাদিস ও সূত্রভিত্তিক আলোচনা', style: TextStyle(color: Colors.white70)),
      ]),
    ),
    const SizedBox(height: 18),
    TextField(onChanged: (v) => setState(() => query = v), decoration: InputDecoration(hintText: 'বিষয় খুঁজুন…', prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
    const SizedBox(height: 20),
    const Text('বিষয়ভিত্তিক আলোচনা', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: navy)),
    const SizedBox(height: 10),
    ...filtered.map((topic) => Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: const Color(0xFFE6F2EF), child: Text(topic.icon, style: const TextStyle(fontSize: 21))),
        title: Text(topic.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(topic.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TopicPage(topic: topic))),
      ),
    )),
    const SizedBox(height: 12),
    const Text('দ্রষ্টব্য: এটি প্রাথমিক কাঠামো। পূর্ণ কনটেন্ট প্রকাশের আগে প্রতিটি অনুবাদ, হাদিসের মান ও ব্যাখ্যা নির্ভরযোগ্য উৎস থেকে যাচাই করতে হবে.', style: TextStyle(fontSize: 12, color: Colors.black54)),
  ]);

  Widget _quranPage() => _evidencePage('quran', 'কুরআনের দলিল', 'কনটেন্ট প্যাকে থাকা আয়াতের রেফারেন্স ও বাংলা সারমর্ম। এটি পূর্ণ কুরআন ডাটাবেস নয়.');
  Widget _hadithPage() => _evidencePage('hadith', 'হাদিস', 'এই সংস্করণে যুক্ত নমুনা হাদিসের সারসংক্ষেপ ও উৎস। সব বিষয়ের হাদিস এখনো যুক্ত হয়নি।');
  Widget _evidencePage(String key, String title, String intro) => FutureBuilder<Map<String, dynamic>>(
    future: rootBundle.loadString('assets/seed_content_bn.json').then((raw) => jsonDecode(raw) as Map<String, dynamic>),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
      if (snapshot.hasError || !snapshot.hasData) return const Center(child: Text('কনটেন্ট লোড করা যায়নি।'));
      final all = <Map<String, dynamic>>[];
      for (final rawTopic in snapshot.data!['topics'] as List<dynamic>) {
        final topic = rawTopic as Map<String, dynamic>;
        for (final rawEvidence in (topic[key] as List<dynamic>? ?? [])) {
          all.add({... (rawEvidence as Map<String, dynamic>), 'topic_title': topic['title']});
        }
      }
      return ListView(padding: const EdgeInsets.all(16), children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navy)),
        const SizedBox(height: 8), Text(intro, style: const TextStyle(height: 1.6)),
        const SizedBox(height: 12),
        if (all.isEmpty) const _Section(title: 'এখনো যুক্ত হয়নি', body: 'এই সংস্করণে যাচাই করা তালিকা নেই।'),
        ...all.map((item) => Card(elevation: 0, color: Colors.white, child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item['topic_title']?.toString() ?? '', style: const TextStyle(fontSize: 12, color: teal, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4), Text(item['reference']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: navy)),
          if (item['grade'] != null) Text('মান: ${item['grade']}', style: const TextStyle(fontSize: 12, color: teal)),
          const SizedBox(height: 6), Text(item['meaning_summary_bn']?.toString() ?? item['summary_bn']?.toString() ?? '', style: const TextStyle(height: 1.6)),
          if (item['url'] != null) SelectableText(item['url'].toString(), style: const TextStyle(fontSize: 12, decoration: TextDecoration.underline)),
        ])))),
        const SizedBox(height: 12),
        const Text('সতর্কতা: এখানে দেখানো বাংলা অর্থ/বর্ণনা সারসংক্ষেপ। প্রকাশের আগে মূল উৎস, অনুবাদ, হাদিসের মান ও লাইসেন্স যাচাই করুন।', style: TextStyle(color: Colors.redAccent, fontSize: 12, height: 1.5)),
      ]);
    },
  );

  Widget _savedPage() => const _InfoPage(title: 'সংরক্ষিত আলোচনা', text: 'বুকমার্ক ও অফলাইন সংরক্ষণ পরবর্তী সংস্করণে যুক্ত করা হবে।');
}

class TopicPage extends StatefulWidget {
  final Topic topic;
  const TopicPage({super.key, required this.topic});
  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  late final Future<Map<String, dynamic>?> _content = _loadContent();

  Future<Map<String, dynamic>?> _loadContent() async {
    final raw = await rootBundle.loadString('assets/seed_content_bn.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final items = data['topics'] as List<dynamic>;
    for (final item in items) {
      final topic = item as Map<String, dynamic>;
      if (topic['title'] == widget.topic.title) return topic;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.topic.title)),
    body: FutureBuilder<Map<String, dynamic>?>(
      future: _content,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final content = snapshot.data;
        if (content == null) {
          return ListView(padding: const EdgeInsets.all(18), children: [
            Text('${widget.topic.icon}  ${widget.topic.title}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navy)),
            const SizedBox(height: 8), Text(widget.topic.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const _Section(title: 'কনটেন্ট প্রস্তুত হচ্ছে', body: 'এই বিষয়ের যাচাইযোগ্য আয়াত, হাদিস, সূত্র ও ব্যাখ্যা পরবর্তী কনটেন্ট আপডেটে যুক্ত করা হবে।'),
            const Text('প্রকাশের আগে প্রতিটি দলিল ও অনুবাদ যোগ্য আলেমের মাধ্যমে যাচাই করতে হবে.', style: TextStyle(color: Colors.redAccent)),
          ]);
        }
        final quran = (content['quran'] as List<dynamic>? ?? []);
        final hadith = (content['hadith'] as List<dynamic>? ?? []);
        final lessons = (content['lessons_bn'] as List<dynamic>? ?? []);
        return ListView(padding: const EdgeInsets.all(18), children: [
          Text('${widget.topic.icon}  ${content['title']}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navy)),
          const SizedBox(height: 8), Text(content['summary']?.toString() ?? widget.topic.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 18),
          const Text('কুরআনের দলিল', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: teal)),
          const SizedBox(height: 8),
          ...quran.map((rawItem) {
            final item = rawItem as Map<String, dynamic>;
            return Card(elevation: 0, color: Colors.white, margin: const EdgeInsets.only(bottom: 10), child: Padding(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(item['reference']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: navy)),
              const SizedBox(height: 10), Text(item['arabic']?.toString() ?? '', textAlign: TextAlign.right, textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 22, height: 1.8)),
              const SizedBox(height: 8), Text('বাংলা অর্থের সারমর্ম: ${item['meaning_summary_bn'] ?? ''}', style: const TextStyle(height: 1.6)),
              Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: () { final url = item['url']?.toString(); if (url != null) showDialog(context: context, builder: (_) => AlertDialog(title: const Text('সূত্র'), content: SelectableText(url), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('বন্ধ করুন'))])); }, icon: const Icon(Icons.link), label: const Text('মূল উৎস'))),
            ])));
          }),
          const SizedBox(height: 8),
          const Text('হাদিসের দলিল', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: teal)),
          const SizedBox(height: 8),
          ...hadith.map((rawItem) {
            final item = rawItem as Map<String, dynamic>;
            return Card(elevation: 0, color: Colors.white, margin: const EdgeInsets.only(bottom: 10), child: Padding(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item['reference']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: navy)),
              const SizedBox(height: 5), Text('মান: ${item['grade'] ?? 'যাচাই প্রয়োজন'}', style: const TextStyle(fontSize: 12, color: teal)),
              const SizedBox(height: 8), Text(item['summary_bn']?.toString() ?? '', style: const TextStyle(height: 1.6)),
              SelectableText(item['url']?.toString() ?? '', style: const TextStyle(fontSize: 12, decoration: TextDecoration.underline)),
            ])));
          }),
          const SizedBox(height: 8),
          _Section(title: 'বিস্তারিত আলোচনা', body: content['discussion_bn']?.toString() ?? ''),
          Card(elevation: 0, color: Colors.white, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('শিক্ষা ও আমল', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: teal)),
            const SizedBox(height: 8), ...lessons.map((lesson) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Text('• $lesson', style: const TextStyle(height: 1.5)))),
          ]))),
          const SizedBox(height: 12),
          const Text('দ্রষ্টব্য: এটি প্রাথমিক কনটেন্ট নমুনা। এখানে সব আয়াত/হাদিস অন্তর্ভুক্ত নয়। প্রকাশের আগে মূল উৎস, অনুবাদ, হাদিস নম্বর ও মান পুনরায় যাচাই এবং যোগ্য আলেমের পর্যালোচনা প্রয়োজন।', style: TextStyle(color: Colors.redAccent, fontSize: 12, height: 1.5)),
        ]);
      },
    ),
  );
}

class _Section extends StatelessWidget {
  final String title, body;
  const _Section({required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Colors.white,
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: teal)), const SizedBox(height: 8), Text(body, style: const TextStyle(height: 1.6))])),
  );
}

class _InfoPage extends StatelessWidget {
  final String title, text;
  const _InfoPage({required this.title, required this.text});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.menu_book, size: 58, color: teal), const SizedBox(height: 16), Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 12), Text(text, textAlign: TextAlign.center, style: const TextStyle(height: 1.7)), const SizedBox(height: 18), const Chip(label: Text('প্রাথমিক সংস্করণ'))])));
}

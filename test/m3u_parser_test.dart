import 'package:flutter_test/flutter_test.dart';
import 'package:live_tv_app/services/m3u_service.dart';
import 'package:live_tv_app/models/channel.dart';

void main() {
  test('M3U Parsing Logic', () {
    final service = M3UService();
    const String sampleM3U = '''
#EXTM3U
#EXTINF:-1 tvg-id="Test.Id" tvg-name="Test Name" tvg-logo="http://logo.png" group-title="News",Display Name
http://stream.m3u8
#EXTINF:-1 group-title="Sports",Sports Channel
http://sports.m3u8
    ''';

    final List<Channel> channels = service.parseM3U(sampleM3U);

    expect(channels.length, 2);
    
    // First Channel
    expect(channels[0].name, 'Display Name');
    expect(channels[0].streamUrl, 'http://stream.m3u8');
    expect(channels[0].logoUrl, 'http://logo.png');
    expect(channels[0].category, 'News');
    expect(channels[0].id, 'Test.Id');

    // Second Channel
    expect(channels[1].name, 'Sports Channel');
    expect(channels[1].category, 'Sports');
  });
}

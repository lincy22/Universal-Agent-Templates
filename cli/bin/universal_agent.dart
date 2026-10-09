import '../lib/universal_agent.dart';

Future<void> main(List<String> args) async {
  final runner = CliRunner();
  await runner.run(args);
}

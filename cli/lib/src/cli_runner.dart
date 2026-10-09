import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

class CliRunner {
  final ArgParser _parser = ArgParser();

  CliRunner() {
    _setupArgParser();
  }

  void _setupArgParser() {
    _parser.addFlag('help', abbr: 'h', negatable: false, help: 'Show usage help.');
    _parser.addFlag('version', abbr: 'v', negatable: false, help: 'Show version information.');

    // Init command options
    final initParser = ArgParser();
    initParser.addOption(
      'tool',
      abbr: 't',
      defaultsTo: 'all',
      allowed: ['antigravity', 'cursor', 'claude', 'copilot', 'windsurf', 'all'],
      help: 'Target AI tool format to generate rules for.',
    );
    _parser.addCommand('init', initParser);

    // List command
    _parser.addCommand('list');

    // Check command
    _parser.addCommand('check');
  }

  Future<void> run(List<String> args) async {
    try {
      final results = _parser.parse(args);

      if (results['help'] as bool || args.isEmpty) {
        _printUsage();
        return;
      }

      if (results['version'] as bool) {
        print('Universal Agent CLI v1.0.0');
        return;
      }

      final command = results.command;
      if (command == null) {
        _printUsage();
        return;
      }

      switch (command.name) {
        case 'init':
          await _handleInit(command);
          break;
        case 'list':
          _handleList();
          break;
        case 'check':
          await _handleCheck();
          break;
        default:
          _printUsage();
      }
    } catch (e) {
      print('Error: $e');
      print('');
      _printUsage();
    }
  }

  void _printUsage() {
    print('Universal Agent Kit CLI');
    print('Usage: universal_agent <command> [options]\n');
    print('Commands:');
    print('  init <language>    Initialize AI agent rules for a language/framework.');
    print('  list               List all supported languages and AI tools.');
    print('  check              Audit current project directory against rules.\n');
    print('Options:');
    print(_parser.usage);
  }

  Future<void> _handleInit(ArgResults commandResults) async {
    final rest = commandResults.rest;
    if (rest.isEmpty) {
      print('Error: Please specify a language (e.g. flutter, react, python, nextjs, go, nodejs, spring-boot).');
      print('Example: universal_agent init flutter --tool cursor');
      return;
    }

    final language = rest.first.toLowerCase();
    final tool = commandResults['tool'] as String;

    final scriptDir = p.dirname(Platform.script.toFilePath());
    Directory templatesDir = Directory(p.normalize(p.join(scriptDir, '..', 'templates')));
    if (!templatesDir.existsSync()) {
      templatesDir = Directory(p.normalize(p.join(Directory.current.path, 'templates')));
    }

    final langTemplateDir = Directory(p.join(templatesDir.path, language));
    if (!langTemplateDir.existsSync()) {
      print('Error: Template for "$language" not found.');
      print('Run "universal_agent list" to see supported languages.');
      return;
    }

    print('Initializing Universal Agent rules for [$language] (Target tool: $tool)...');

    final rulesFile = File(p.join(langTemplateDir.path, 'AGENT_RULES.md'));
    if (!rulesFile.existsSync()) {
      print('Error: AGENT_RULES.md missing for $language.');
      return;
    }

    final content = rulesFile.readAsStringSync();
    final targetDir = Directory.current;

    if (tool == 'antigravity' || tool == 'all') {
      final agentDir = Directory(p.join(targetDir.path, '.agent'));
      if (!agentDir.existsSync()) agentDir.createSync(recursive: true);
      File(p.join(agentDir.path, 'RULES.md')).writeAsStringSync(content);
      print('  Created .agent/RULES.md (Antigravity)');
    }

    if (tool == 'cursor' || tool == 'all') {
      File(p.join(targetDir.path, '.cursorrules')).writeAsStringSync(content);
      print('  Created .cursorrules (Cursor)');
    }

    if (tool == 'claude' || tool == 'all') {
      File(p.join(targetDir.path, 'CLAUDE.md')).writeAsStringSync(content);
      print('  Created CLAUDE.md (Claude Code)');
    }

    if (tool == 'copilot' || tool == 'all') {
      final githubDir = Directory(p.join(targetDir.path, '.github'));
      if (!githubDir.existsSync()) githubDir.createSync(recursive: true);
      File(p.join(githubDir.path, 'copilot-instructions.md')).writeAsStringSync(content);
      print('  Created .github/copilot-instructions.md (GitHub Copilot)');
    }

    if (tool == 'windsurf' || tool == 'all') {
      File(p.join(targetDir.path, '.windsurfrules')).writeAsStringSync(content);
      print('  Created .windsurfrules (Windsurf)');
    }

    print('\nSuccessfully installed AI Agent Rules for $language!');
  }

  void _handleList() {
    print('Supported Languages & Frameworks:');
    print('  - flutter      - Flutter / Dart Architecture & Rules');
    print('  - react        - React (TypeScript/JavaScript) Clean Rules');
    print('  - python       - Python (FastAPI/Django/PyTest) Standards');
    print('  - nextjs       - Next.js App Router Rules');
    print('  - nodejs       - Node.js Express/NestJS Rules');
    print('  - spring-boot  - Java / Spring Boot Architecture');
    print('  - go           - Go Idiomatic Rules & Standards\n');
    print('Supported AI Tools:');
    print('  - antigravity  (.agent/RULES.md)');
    print('  - cursor       (.cursorrules)');
    print('  - claude       (CLAUDE.md)');
    print('  - copilot      (.github/copilot-instructions.md)');
    print('  - windsurf     (.windsurfrules)');
    print('  - all          (Generates rules for all tools above)');
  }

  Future<void> _handleCheck() async {
    print('Running Universal Agent Code Audit...');
    final currentPath = Directory.current.path;
    print('Scanning: $currentPath\n');

    bool pass = true;

    final agentDir = Directory(p.join(currentPath, '.agent'));
    final cursorRules = File(p.join(currentPath, '.cursorrules'));
    final claudeRules = File(p.join(currentPath, 'CLAUDE.md'));

    if (!agentDir.existsSync() && !cursorRules.existsSync() && !claudeRules.existsSync()) {
      print('  Warning: No AI Agent rules file detected in project root.');
      print('  Run "universal_agent init <language>" to generate rules.');
      pass = false;
    } else {
      print('  Agent rule file detected.');
    }

    final envExample = File(p.join(currentPath, '.env.example'));
    final envFile = File(p.join(currentPath, '.env'));
    if (envFile.existsSync() && !envExample.existsSync()) {
      print('  Recommendation: Create .env.example for public repo security.');
    }

    print('');
    if (pass) {
      print('All basic checks passed successfully!');
    } else {
      print('Audit completed with recommendations.');
    }
  }
}

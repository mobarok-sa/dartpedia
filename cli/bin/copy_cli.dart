//copy_cli.dart
// a working version of cli application
// which is get artcle summary from wikipedia

// import 'package:cli/cli.dart' as cli;
import 'dart:io';
import 'package:http/http.dart' as http;

 const version = '0.0.1';

void main(List<String> arguments) {
 
  if (arguments.isEmpty || arguments.first == 'help') {
      printUsage();   
  } else if (arguments.first == 'version') {
      print('Dartpedia CLI version $version');
  } else if (arguments.first == 'wikipedia') {
      final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
      serachWikipedia(inputArgs);
  } else {
      printUsage();
  }
  
}


void serachWikipedia(List<String>? arguments) async {
  final String articleTitle;

  if (arguments == null || arguments.isEmpty) {
    print("Please provide an article title.");
    final inputFromStdin = stdin.readLineSync();
    if (inputFromStdin == null || inputFromStdin.isEmpty) {
      print("No article title provided. Exiting.");
      return; // exit fun. if no valid input.
    }
    articleTitle = inputFromStdin;
  } else {
    articleTitle = arguments.join(' ');
  }

  print("Looking up articles about '$articleTitle'. Please wait.");
  // call api and wait result
  var articleContent = await getWikipediaArticle(articleTitle);
  print(articleContent);  // Print the full article response (raw JSON for now)


}


Future<String> getWikipediaArticle(String articleTitle) async {
  final url = Uri.https(
    'en.wikipedia.org', // Wikipedia API domain
    '/api/rest_v1/page/summary/$articleTitle', // API path for article summary
    );
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return response.body;
  }
  // if error
  return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';


}

void printUsage() {
  print("The following command are valid: 'help', 'version', 'wikipedia <ARTICLE-TITLE>'");
}




import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/ravelry_project.dart';

class RavelryHelper {
  static final String _rootUrl = 'https://api.ravelry.com';

  static const RAVELRY_USERNAME = 'read-851f228b0d99b230242bc2bea3fd8e0c';
  static const RAVELRY_PASSWORD = 'qdvCL9lpbfa04govu9qVNLaC4/adl7UjmbZRsT04';

  static Future<RavelryProject> getProject() async {
    RavelryProject ravelryProject; //sjal med floeser

    int id = Random().nextInt(1251731); // max id for now?

    // url for GET request
    var url = Uri.parse('$_rootUrl/patterns.json?ids=$id');

    // basic authentication for the header
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$RAVELRY_USERNAME:$RAVELRY_PASSWORD'))}';

    // http GET request sent to the url with the header
    var response = await http.get(url, headers: <String, String>{
      'Authorization': basicAuth,
    });

    // successful response
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      var responseProject = jsonResponse['patterns']['$id'];

      if ((responseProject['photos'] as List<dynamic>).length < 1) {
        return getProject();
      }

      ravelryProject = RavelryProject(
        name: responseProject['name'] ?? '',
        ravelryLink: responseProject['permalink'] ?? '',
        photoUrl: responseProject['photos'][0]['medium_url'] ?? '',
        patternDesigner: responseProject['pattern_author']['name'] ?? '',
        patternId: id,
        free: responseProject['free'] ?? false,
        sizes_available: responseProject['sizes_available'] ?? '',
        notes: responseProject['notes'] ?? '',
        yardage_description: responseProject['yardage_description'] ?? '',
        yarn_weight_description:
            responseProject['yarn_weight_description'] ?? '',
        needle_sizes: _getNeedleSizes(responseProject['pattern_needle_sizes']),
        gauge_description: responseProject['gauge_description'] ?? '',
      );

      if (ravelryProject.name == '' ||
          ravelryProject.photoUrl == '' ||
          ravelryProject.ravelryLink == '' ||
          ravelryProject.patternDesigner == '' ||
          !isKnitting(responseProject['pattern_needle_sizes'])) {
        return getProject();
      } else {
        return ravelryProject;
      }
    } else {
      return getProject();
    }
  }

  // gets the needle sizes for the ravelry project
  static List<String> _getNeedleSizes(List<dynamic> responseSizes) {
    List<String> needleSizes = [];

    responseSizes.forEach((needle) {
      needleSizes.add(needle['name']);
    });

    return needleSizes;
  }

  static bool isKnitting(List<dynamic> needles) {
    bool isKnitting = false;
    needles.forEach((needle) {
      if (needle['knitting']) {
        isKnitting = true;
      }
    });
    return isKnitting;
  }
}

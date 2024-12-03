import 'package:http/http.dart' as http;
import 'dart:convert';

class AppNetworking {
  // TODO possibly modify this to use a config file
  // Variable to store server
  static const String server = 'http://sdd.syedahmad.tech:8080';

  // Signup Attempt
  Future<bool> attemptSignup(
      String username, String password, String fname, String lname) async {
    try {
      final response = await http.post(
        Uri.parse('$server/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([username, password, fname, lname]),
      );

      //print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      return false;
    }
  }

  // Login Attempt
  Future<List> attemptLogin(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$server/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([username, password]),
      );

      //print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      // On error or no internet
      return [false];
    }
  }

  // Send run data
  // Already in sendable JSON
  Future<bool> sendRundata(String rundata) async {
    try {
      final response = await http.post(
        Uri.parse('$server/rundata'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: rundata,
      );

      //print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      // On error or no internet
      return false;
    }
  }

  // Get run data
  Future<String> getRundata(String username, String filename) async {
    try {
      final response = await http.post(
        Uri.parse('$server/getrundata'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([username, filename]),
      );

      //print(response.body);
      // Return the encoded json as that is what is written to the file anyway
      return response.body;
    } catch (e) {
      // On error or no internet
      return "error";
    }
  }

  // Fetch run history
  Future<Map<String, dynamic>> fetchHistoryStatus(
      String username, List<String> titleList) async {
    try {
      final response = await http.post(
        Uri.parse('$server/historystatus'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([username, titleList]),
      );

      //print(response.body);
      return jsonDecode(response.body);

      // If client need runs, ask for them from server
      // If server need some runs, ask for them (or get them) and send
      // client fine, client send, server send, both

      // later use if(error) return function
    } catch (e) {
      // On error or no internet
      return {"error": true};
    }
  }

  // Send our location to server for nearby functions
  Future<bool> sendLocation(String username, double lat, double long) async {
    try {
      final response = await http.post(
        Uri.parse('$server/sendlocation'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([username, lat, long]),
      );

      //print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      return false;
    }
  }

  // Get other users locations from server for nearby functions
  Future<String> getLocations(String username, double lat, double long) async {
    try {
      final response = await http.post(
        Uri.parse('$server/getlocations'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([username, lat, long]),
      );

      /*
      List returnData = [];
      returnData.add(List<String>.from(data[0]));
      returnData.add(List<String>.from(data[1]));
      returnData.add(List<double>.from(data[2]));
      returnData.add(List<double>.from(data[3]));
      returnData.add(List<int>.from(data[4]));
      returnData.add(data[5]);
      */

      // Return only the body so that we can parse in notifier, so it is happy
      // about the types assigned
      return response.body;
    } catch (e) {
      return "Fail";
    }
  }

  // Function to get leaderboards for logged in user
  Future<String> getLeaderboards(String username) async {
    try {
      final response = await http.post(
        Uri.parse('$server/leaderboard'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([username]),
      );

      // Return only the body so that we can parse in notifier, so it is happy
      // about the types assigned
      return response.body;
    } catch (e) {
      return "Fail";
    }
  }

  // Get info about a user
  Future<List<dynamic>> getUserInfo(String myUname, String theirUname) async {
    try {
      final response = await http.post(
        Uri.parse('$server/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([myUname, theirUname]),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return ["Fail"];
    }
  }

  // Function to friend a user
  Future<bool?> friendUser(String myUname, String friend, bool status) async {
    try {
      final response = await http.post(
        Uri.parse('$server/friends'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([myUname, friend, status]),
      );

      return jsonDecode(response.body);
    } catch (e) {
      // Since the value could be true or false, return null as a third
      // different value
      return null;
    }
  }

  // Function to change the users send location for nearby setting, this also
  // deletes any current location data from the server
  Future<bool> changeLocationSetting(String uname, bool value) async {
    try {
      final response = await http.post(
        Uri.parse('$server/locationsetting'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([uname, value]),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return false;
    }
  }

  // Function to change the users selected countries
  Future<bool> changeCountry(String uname, String country) async {
    try {
      final response = await http.post(
        Uri.parse('$server/countrysetting'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([uname, country]),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return false;
    }
  }

  // Function for the user to change thier first name
  Future<bool> changeFname(String uname, String newName) async {
    try {
      final response = await http.post(
        Uri.parse('$server/firstnames'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([uname, newName]),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return false;
    }
  }

  // Function for the user to change thier last name
  Future<bool> changeLname(String uname, String newName) async {
    try {
      final response = await http.post(
        Uri.parse('$server/lastnames'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([uname, newName]),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return false;
    }
  }

  // Function for the user to reset all their run data from their server
  Future<bool> resetData(String uname) async {
    try {
      final response = await http.post(
        Uri.parse('$server/resetdata'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([uname]),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return false;
    }
  }
}

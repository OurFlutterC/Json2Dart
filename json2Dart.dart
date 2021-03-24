import 'dart:convert';
import 'dart:io';

Map mdl = {};
Map json2Dart(String inputUser, String className) {
  className = className.isEmpty
      ? "MyModel"
      : className.substring(0, 1).toUpperCase() + className.substring(1);

  inputUser = inputUser.isEmpty ? '{"mcPackage":"mc"}' : inputUser;
  try {
    var jsonInputUser = json.decode(inputUser.trim());
    String data = "";
    String parameters = "";
    String fromVar = "";
    String toVar = "";
    String initial = "";
    String tj = "";
    String multi = "";
    if (jsonInputUser is List) {
      initial = "\n\n  multi = multi ?? [];\n";
      data += " List multi;\n";
      multi = """\n\nvoid setMulti(List d) {
        List r = d.map((e) {
          $className m = $className();
          m.fromJson(e);
          return m;
            }).toList();
            multi = r;
          }\n""";

      for (Map i in jsonInputUser) {
        for (String u in i.keys) {
          if (i[u] is String) {
            data += """ String $u;\n""";
            fromVar += "  $u = json['$u'] ?? $u;\n";
            parameters += """  this.$u,\n""";
            toVar += "  data['$u'] = this.$u$tj;\n";
          } else if (i[u] is num && i[u].toString().contains(".")) {
            data += """ double $u;\n""";
            fromVar += "  $u = json['$u'] ?? $u;\n";
            parameters += """  this.$u,\n""";
            toVar += "  data['$u'] = this.$u$tj;\n";
          } else if (i[u] is int) {
            data += """ int $u;\n""";
            fromVar += "  $u = json['$u'] ?? $u;\n";
            parameters += """  this.$u,\n""";
            toVar += "  data['$u'] = this.$u$tj;\n";
          } else if (i[u] is List) {
            if (i[u][0] is List) {
              String mdl = u.substring(0, 1).toUpperCase() + u.substring(1);
              json2Dart(json.encode(i[u]), mdl);
              data += """ $mdl $u;\n""";
              initial += "  $u ??= $mdl();\n";
              fromVar += "  $u.fromJson(json['$u'] ?? $u.toJson());\n";
              tj = ".toJson()";
              parameters += """  this.$u,\n""";
              toVar += "  data['$u'] = this.$u$tj;\n";
              tj = "";
            } else if (i[u][0] is Map) {
              String mdl = u.substring(0, 1).toUpperCase() + u.substring(1);
              json2Dart(json.encode(i[u]), mdl);
              data += """ $mdl $u;\n""";
              initial += "  $u ??= $mdl();\n";
              fromVar += "  $u.fromJson(json['$u'] ?? $u.toJson());\n";
              tj = ".toJson()";
              parameters += """  this.$u,\n""";
              toVar += "  data['$u'] = this.$u$tj;\n";
              tj = "";
            } else {
              data += """ List $u;\n""";
              fromVar += "  $u = json['$u'] ?? $u;\n";
              parameters += """  this.$u,\n""";
              toVar += "  data['$u'] = this.$u$tj;\n";
            }
          } else if (i[u] is Map) {
            String mdl = u.substring(0, 1).toUpperCase() + u.substring(1);
            json2Dart(json.encode(i[u]), mdl);
            data += """ $mdl $u;\n""";
            initial += "  $u ??= $mdl();\n";
            fromVar += "  $u.fromJson(json['$u'] ?? $u.toJson());\n";
            tj = ".toJson()";
            parameters += """  this.$u,\n""";
            toVar += "  data['$u'] = this.$u$tj;\n";
            tj = "";
          } else {
            print("\n>> See this type is not their .\n");
          }
        }
        break;
      }
    } else {
      for (String u in jsonInputUser.keys) {
        if (jsonInputUser[u] is String) {
          data += """ String $u;\n""";
          fromVar += "  $u = json['$u'] ?? $u;\n";
          parameters += """  this.$u,\n""";
          toVar += "  data['$u'] = this.$u$tj;\n";
        } else if (jsonInputUser[u] is num &&
            jsonInputUser[u].toString().contains(".")) {
          data += """ double $u;\n""";
          fromVar += "  $u = json['$u'] ?? $u;\n";
          parameters += """  this.$u,\n""";
          toVar += "  data['$u'] = this.$u$tj;\n";
        } else if (jsonInputUser[u] is int) {
          data += """ int $u;\n""";
          fromVar += "  $u = json['$u'] ?? $u;\n";
          parameters += """  this.$u,\n""";
          toVar += "  data['$u'] = this.$u$tj;\n";
        } else if (jsonInputUser[u] is List) {
          if (jsonInputUser[u][0] is List) {
            String mdl = u.substring(0, 1).toUpperCase() + u.substring(1);
            json2Dart(json.encode(jsonInputUser[u]), mdl);
            data += """ $mdl $u;\n""";
            initial += "  $u ??= $mdl();\n";
            fromVar += "  $u.fromJson(json['$u'] ?? $u.toJson());\n";
            tj = ".toJson()";
            parameters += """  this.$u,\n""";
            toVar += "  data['$u'] = this.$u$tj;\n";
            tj = "";
          } else if (jsonInputUser[u][0] is Map) {
            String mdl = u.substring(0, 1).toUpperCase() + u.substring(1);
            json2Dart(json.encode(jsonInputUser[u]), mdl);
            data += """ $mdl $u;\n""";
            initial += "  $u ??= $mdl();\n";
            fromVar += "  $u.fromJson(json['$u'] ?? $u.toJson());\n";
            tj = ".toJson()";
            parameters += """  this.$u,\n""";
            toVar += "  data['$u'] = this.$u$tj;\n";
            tj = "";
          } else {
            data += """ List $u;\n""";
            fromVar += "  $u = json['$u'] ?? $u;\n";
            parameters += """  this.$u,\n""";
            toVar += "  data['$u'] = this.$u$tj;\n";
          }
        } else if (jsonInputUser[u] is Map) {
          List a = [];
          a.add(jsonInputUser[u]);
          String mdl = u.substring(0, 1).toUpperCase() + u.substring(1);
          json2Dart(json.encode(a), mdl);
          data += """ $mdl $u;\n""";
          initial += "  $u ??= $mdl();\n";
          fromVar += "  $u.fromJson(json['$u'] ?? $u.toJson());\n";
          tj = ".toJson()";
          parameters += """  this.$u,\n""";
          toVar += "  data['$u'] = this.$u$tj;\n";
          tj = "";
        } else {
          print("\n>> Invalid .\n");
        }
      }
    }

    fromVar += "  return super.fromJson(json);\n";

    String toJson =
        " Map<String, dynamic> toJson() {\n final Map<String, dynamic> data = new Map<String, dynamic>();";
    String fromJson = " fromJson(Map<String, dynamic> json) {";
    String headClass = "class $className extends McModel{\n";
    String constractor = " $className({";
    String init = initial.isNotEmpty ? "}" : ";";
    String it = initial.isNotEmpty ? "{\n" : "";
    String model = headClass +
        data +
        "\n" +
        constractor +
        "\n" +
        parameters +
        " })" +
        it +
        initial +
        init +
        "\n" +
        fromJson +
        "\n" +
        fromVar +
        " }\n" +
        "\n\n" +
        toJson +
        "\n" +
        toVar +
        "\n" +
        "  return data;" +
        "\n }" +
        multi +
        "\n" +
        "}";

    mdl[className] = model;

    return mdl;
  } catch (e) {
    print("[-] $e");
    return {"error": "[-Error] $e"};
  }
}

//String getData(link) {}

void main() {
  print(" [+] Your Json data or path json file: ");
  String? data = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);
  print(" [+] Your dart class name (default name MyModel):");
  String? className =
      stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);

  try {
    //  if (data.substring(4) == "http"){
    //    Map api = getData(data);
    //  }else{
    if (data!.contains(".json")) {
      data = File(data).readAsStringSync();
    }
    json2Dart(data, className!);

    
    for (String item in mdl.keys) {
      File("${item}Model.dart").writeAsString(
          mdl[item.substring(0, 1).toUpperCase() + item.substring(1)]);
    }
  } catch (e) {
    print("[-] $e");
  }
}

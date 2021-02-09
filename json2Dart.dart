import 'dart:convert';
import 'dart:io';

void json2Dart(String inputUser, className) {
  try {
    List jsonInputUser = json.decode(inputUser);
    String data = "";
    String parameters = "";
    String fromVar = "";
    String toVar = "";
    for (Map i in jsonInputUser) {
      for (String u in i.keys) {
        String t = i[u].runtimeType.toString();
        data += """ $t $u;\n""";
        parameters += """  this.$u,\n""";
        fromVar += "  $u = json['$u'] ?? $u;\n";
        toVar += "  data['$u'] = this.$u;\n";
      }
      break;
    }
    data += " List multi = [];\n";
    fromVar += "  return super.fromJson(json);\n";
    String multi = """\n\nvoid setMulti(List d) {
    List r = d.map((e) {
      $className m = $className();
      m.fromJson(e);
      return m;
    }).toList();
    multi = r;
  }\n""";
    String toJson =
        " Map<String, dynamic> toJson() {\n final Map<String, dynamic> data = new Map<String, dynamic>();";
    String fromJson = " fromJson(Map<String, dynamic> json) {";
    String class_ = "class $className extends McModel{\n";
    String constractor = " $className({";
    String model = class_ +
        data +
        "\n" +
        constractor +
        "\n" +
        parameters +
        " });\n" +
        "\n" +
        fromJson +
        "\n" +
        fromVar +
        " }" +
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
    File("${className}Model.dart").writeAsString(model);
    print(model);
  } catch (e) {
    print("[-] $e");
  }
}

//String getData(link) {}

void main() {
  print(" [+] Your Json data or path file or link Api: ");
  String data = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
  print(" [+] Your dart class name (default name MyModel):");
  String className = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
  if (className.length == 0) {
    className = "MyModel";
  }

  try {
    //  if (data.substring(4) == "http"){
    //    Map api = getData(data);
    //  }else{
    if (data.contains(".json")) {
      data = File(data).readAsStringSync();
    }

    json2Dart(data, className);
  } catch (e) {
    print("[-] $e");
  }
}

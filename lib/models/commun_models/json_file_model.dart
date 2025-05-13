class JsonFileModel {
  List<String>? singleAnk;
  List<String>? jodi;
  List<ThreePana>? singlePana;
  List<ThreePana>? doublePana;
  List<String>? triplePana;
  List<String>? allThreePana;
  List<String>? allDoublePana;
  List<String>? allSinglePana;
  Map<String, List<List<String>>>? panelGroupChart;
  Map<String, List<String>>? spdptp;
  Map<String, dynamic>? spdptpChart;
  List<String>? groupJodi;
  JsonFileModel({
    this.singleAnk,
    this.jodi,
    this.singlePana,
    this.doublePana,
    this.triplePana,
    this.allDoublePana,
    this.allSinglePana,
    this.allThreePana,
    this.panelGroupChart,
    this.spdptp,
    this.spdptpChart,
    this.groupJodi,
  });

  JsonFileModel.fromJson(Map<String, dynamic> json) {
    singleAnk = json['single_digit'].cast<String>();
    jodi = json['jodi_digit'].cast<String>();
    if (json['single_pana'] != null) {
      singlePana = <ThreePana>[];
      json['single_pana'].forEach((v) {
        singlePana!.add(ThreePana.fromJson(v));
      });
    }
    if (json['double_pana'] != null) {
      doublePana = <ThreePana>[];
      json['double_pana'].forEach((v) {
        doublePana!.add(ThreePana.fromJson(v));
      });
    }
    triplePana = json['triple_pana'].cast<String>();
    allSinglePana = json['all_single_pana'].cast<String>();
    allDoublePana = json['all_double_pana'].cast<String>();
    allThreePana = json['all_three_pana'].cast<String>();
    if (json['panelGroupChart'] != null) {
      panelGroupChart = {};
      (json['panelGroupChart'] as Map<String, dynamic>).forEach((key, value) {
        panelGroupChart![key] = List<List<String>>.from((value as List)
            .map((e) => List<String>.from(e.map((x) => x.toString()))));
      });
    } else {
      panelGroupChart = {};
    }
    if (json['spdptp'] != null) {
      spdptp = {};
      (json['spdptp'] as Map<String, dynamic>).forEach((key, value) {
        spdptp![key] = List<String>.from(value.map((x) => x.toString()));
      });
    }
    if (json['SPDPTPChart'] != null) {
      spdptpChart = {};
      (json['SPDPTPChart'] as Map<String, dynamic>).forEach((key, value) {
        spdptpChart![key] = {
          "SP": List<String>.from(value["SP"].map((x) => x.toString())),
          "DP": List<String>.from(value["DP"].map((x) => x.toString())),
          "TP": List<String>.from(value["TP"].map((x) => x.toString())),
        };
      });
    }
    if (json['groupJodi'] != null) {
      groupJodi = List<String>.from(json['groupJodi'].map((v) => v.toString()))
          .cast<String>();
    } else {
      groupJodi = null; // Handle the case when 'groupJodi' is null in the JSON
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['single_digit'] = singleAnk;
    data['jodi_digit'] = jodi;
    if (singlePana != null) {
      data['single_pana'] = singlePana!.map((v) => v.toJson()).toList();
    }
    if (doublePana != null) {
      data['double_pana'] = doublePana!.map((v) => v.toJson()).toList();
    }
    data['triple_pana'] = triplePana;
    data['panelGroupChart'] = panelGroupChart; // Convert panelGroupChart to map
    data['spdptp'] = spdptp;
    if (spdptpChart != null) {
      data['SPDPTPChart'] = spdptpChart;
    }
    data['groupJodi'] = groupJodi;
    return data;
  }
}

class ThreePana {
  List<String>? l0;
  List<String>? l1;
  List<String>? l2;
  List<String>? l3;
  List<String>? l4;
  List<String>? l5;
  List<String>? l6;
  List<String>? l7;
  List<String>? l8;
  List<String>? l9;

  ThreePana({
    this.l0,
    this.l1,
    this.l2,
    this.l3,
    this.l4,
    this.l5,
    this.l6,
    this.l7,
    this.l8,
    this.l9,
  });

  ThreePana.fromJson(Map<String, dynamic> json) {
    l0 = json['0'].cast<String>();
    l1 = json['1'].cast<String>();
    l2 = json['2'].cast<String>();
    l3 = json['3'].cast<String>();
    l4 = json['4'].cast<String>();
    l5 = json['5'].cast<String>();
    l6 = json['6'].cast<String>();
    l7 = json['7'].cast<String>();
    l8 = json['8'].cast<String>();
    l9 = json['9'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['0'] = l0;
    data['1'] = l1;
    data['2'] = l2;
    data['3'] = l3;
    data['4'] = l4;
    data['5'] = l5;
    data['6'] = l6;
    data['7'] = l7;
    data['8'] = l8;
    data['9'] = l9;
    return data;
  }
}

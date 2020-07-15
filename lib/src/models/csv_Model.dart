

import 'dart:convert';

SubmitModel submitModelFromJson(String str) => SubmitModel.fromJson(json.decode(str));

String submitModelToJson(SubmitModel data) => json.encode(data.toJson());

class SubmitModel {
    SubmitModel({
        this.param1,
        this.param2,
        this.param3,
        this.param4,
    });

    String param1;
    String param2;
    int param3;
    int param4;

    factory SubmitModel.fromJson(Map<String, dynamic> json) => SubmitModel(
        param1: json["param1"],
        param2: json["param2"],
        param3: json["param3"],
        param4: json["param4"],
    );

    Map<String, dynamic> toJson() => {
        "param1": param1,
        "param2": param2,
        "param3": param3,
        "param4": param4,
    };
}

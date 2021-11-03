import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Note{

  late String _noteTitle;
  late String _createdAt;
  late String _description;
  late String _color;

  Note(this._noteTitle, this._description, this._createdAt, this._color);
  Note.fromSnapshot(Map<String, dynamic> data){
    this._noteTitle=data['noteTitle'];
    this._description=data['description'];
    this._createdAt=data['createdAt'];
    this._color=data['color'];
  }
  Map<String, dynamic> toMap(){
    Map<String, dynamic> map={
      'noteTitle':this._noteTitle,
      'description':this._description,
      'createdAt':this._createdAt,
      'color':this.color
    };

    return map;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get createdAt => _createdAt;

  set createdAt(String value) {
    _createdAt = value;
  }

  String get color => _color;

  set color(String value) {
    _color = value;
  }

  String get noteTitle => _noteTitle;

  set noteTitle(String value) {
    _noteTitle = value;
  }
}
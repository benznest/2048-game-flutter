import 'package:game_2048_flutter/block_unit.dart';
import 'dart:math';
import 'package:flutter/material.dart';

const int COUNT_BLOCK_TYPE = 12;
const int BLOCK_VALUE_NONE = 1;
const int BLOCK_VALUE_2 = 2;
const int BLOCK_VALUE_4 = 4;
const int BLOCK_VALUE_8 = 8;
const int BLOCK_VALUE_16 = 16;
const int BLOCK_VALUE_32 = 32;
const int BLOCK_VALUE_64 = 64;
const int BLOCK_VALUE_128 = 128;
const int BLOCK_VALUE_256 = 256;
const int BLOCK_VALUE_512 = 512;
const int BLOCK_VALUE_1024 = 1024;
const int BLOCK_VALUE_2048 = 2048;
const int BLOCK_VALUE_4096 = 4096;
const int BLOCK_VALUE_8192 = 8192;
const int BLOCK_VALUE_16384 = 16384;
const int BLOCK_VALUE_32768 = 32768;

class BlockUnitManager {
  static BlockUnit randomBlock({int maxPow = COUNT_BLOCK_TYPE}) {
    Random random = Random();
    int value = pow(2, random.nextInt(maxPow)).toInt();
    return create(value);
  }

  static BlockUnit randomSimpleBlock() {
    Random random = Random();
    int value = random.nextInt(2);
    if (value == 0) {
      return create(BLOCK_VALUE_2);
    }
    return create(BLOCK_VALUE_4);
  }


  static BlockUnit create(int value) {
    if (value == BLOCK_VALUE_NONE) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffccc0b3),
          colorText: Color(0x00ffffff));
    } else if (value == BLOCK_VALUE_2) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffeee4d9),
          colorText: Color(0xff776e64));
    } else if (value == BLOCK_VALUE_4) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffede0c8),
          colorText: Color(0xff776e64));
    } else if (value == BLOCK_VALUE_8) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xfff2b179),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_16) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xfff49663),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_32) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xfff77b63),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_64) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xfff45639),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_128) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffedce71),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_256) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xfff0cb63),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_512) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffecc752),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_1024) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffeec62c),
          colorText: Color(0xffffffff),
          fontSize: 26);
    } else if (value == BLOCK_VALUE_2048) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffeec309),
          colorText: Color(0xffffffff),
          fontSize: 26);
    } else if (value == BLOCK_VALUE_4096) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffe67e22),
          colorText: Color(0xffffffff),
          fontSize: 26);
    } else if (value == BLOCK_VALUE_8192) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xff9b59b6),
          colorText: Color(0xffffffff),
          fontSize: 26);
    } else {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xff8e44ad),
          colorText: Color(0xffffffff),
          fontSize: 22);
    }
  }
}
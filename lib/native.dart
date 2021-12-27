import 'dart:ffi';
import 'dart:io';

final DynamicLibrary nativeSolveLib = Platform.isAndroid ? DynamicLibrary.open("libsolver.so") : DynamicLibrary.process();
final Pointer<Int32> Function(Pointer<Int32> list, int size) solve = nativeSolveLib.lookup<NativeFunction<Pointer<Int32> Function(Pointer<Int32>,Int32)>>("solve").asFunction<Pointer<Int32> Function(Pointer<Int32>, int)>();
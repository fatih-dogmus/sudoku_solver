cmake_minimum_required(VERSION 3.4.1)

include_directories(../include)

add_library(libopencv SHARED IMPORTED)
set_target_properties(libopencv PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/app/src/main/jniLibs/${ANDROID_ABI}/libopencv_java4.so)

add_library(solver SHARED ../solver/solver.cpp )

find_library(log-lib log)

target_link_libraries(solver libopencv ${log-lib})
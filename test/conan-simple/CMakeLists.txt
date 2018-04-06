 project(conan-simple)
 cmake_minimum_required(VERSION 3.0.0)

 include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
 conan_basic_setup()

 add_executable(out main.c)
 #target_link_libraries(timer ${CONAN_LIBS})

 install(TARGETS out
         DESTINATION .)

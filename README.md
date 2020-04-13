# cmake-qtest-discovery
CMake modules providing automatic test discovery from Qt Tests

## Introduction

Since version 3.10, CMake is able to retrieve the list of tests from a Google Test executable, see [this blog entry](https://blog.kitware.com/dynamic-google-test-discovery-in-cmake-3-10/) for more information.

This repository contains similar modules for QTest, the Qt test framework.

## Quick start guide

* add the modules to your project
* include(QtTest)
* call qtest_discover_tests on the test executable, for instance: ```qtest_discover_tests(my_qtest_exe)```
* build "my_qtest_exe". This will run "my_qtest_exe -datatags" as a POST_BUILD action and pass the information to CMake
* run ctest

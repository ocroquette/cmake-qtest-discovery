# Copyright 2020 Olivier Croquette <ocroquette@free.fr>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
# WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
# THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# v1.0
#
# Latest version is available from GitHub:
# https://github.com/ocroquette/cmake-qtest-discovery

#[=======================================================================[.rst:
QtTest
----------

This module defines functions to help use the Qt Test infrastructure.
The main function is :command:`qtest_discover_tests`.

.. command:: qtest_discover_tests

  Automatically add tests with CTest by querying the compiled test executable
  for available tests::

    qtest_discover_tests(target)

  ``qtest_discover_tests`` sets up a post-build command on the test executable
  that generates the list of tests by parsing the output from running the test
  with the ``-datatags`` argument. This ensures that the full list of
  tests, including instantiations of parameterized tests, is obtained.  Since
  test discovery occurs at build time, it is not necessary to re-run CMake when
  the list of tests changes.
#]=======================================================================]

function(qtest_discover_tests TARGET)
  set(ctest_file_base "${CMAKE_CURRENT_BINARY_DIR}/${TARGET}")
  set(ctest_include_file "${ctest_file_base}_tests.cmake")
  add_custom_command(TARGET ${TARGET}
    POST_BUILD
    COMMAND "${CMAKE_COMMAND}"
      -D "TEST_EXECUTABLE:FILEPATH=$<TARGET_FILE:${TARGET}>"
      -D "CTEST_FILE:FILEPATH=${ctest_include_file}"
      -P "${_QTTEST_DISCOVER_TESTS_SCRIPT}"
    BYPRODUCTS "${ctest_include_file}"
  )

  set_property(DIRECTORY APPEND PROPERTY TEST_INCLUDE_FILES
    "${ctest_include_file}"
  )
endfunction()


###############################################################################

set(_QTTEST_DISCOVER_TESTS_SCRIPT
  ${CMAKE_CURRENT_LIST_DIR}/QtTestAddTests.cmake
)

cmake_minimum_required(VERSION 3.5)

# Set the project name
project (google_test_example)


#############################################
# Unit tests

# enable CTest testing
enable_testing()

# Add a testing executable
add_executable(unit_tests src/unit_tests.cpp)

#compiler with the -I flag eg. -I/directory/path
target_include_directories(unit_tests PUBLIC "/home/wzy/app/googletest-release-1.10.0/googletest/include")

#find libgtest.so library
find_library(GTEST 
    gtest 
    "/home/wzy/app/googletest-build-release-1.10/lib" )
find_library(GTEST_MAIN 
    gtest_main 
    "/home/wzy/app/googletest-build-release-1.10/lib" )    

IF (NOT GTEST)
    MESSGAGE(FATAL_ERROR "libgtest.so not found")
ENDIF(NOT GTEST)

IF (NOT GTEST_MAIN)
    MESSGAGE(FATAL_ERROR "libgtest_main.so not found")
ENDIF(NOT GTEST_MAIN)

message(STATUS " gtest path : " ${GTEST})
message(STATUS " gtest_main path : " ${GTEST_MAIN})

target_link_libraries(unit_tests
    ${GTEST} 
    ${GTEST_MAIN}
)

#To add a test you call the add_test() function. This will create a named test which will run the supplied command.
add_test(test_all unit_tests)

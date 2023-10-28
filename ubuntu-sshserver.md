# Dockerfile, ubuntu-sshserver.dockerfile

## Description
* This dockerfile uses the image, ubuntu:latest.
* Setup the ssh-server and export the port 22.
* Also, create a user for logging the environment remotely.
* The `googleTest` package is also installed.

## Usage

Use the below command to create the docker image
```
docker build -t crow/ubuntu:sshd -f ./ubuntu-sshserver.dockerfile .
``````
Use the below command to start the build environment with ssh-server.# 

```
docker run --privileged -d --rm -p 22:22 -v $PWD:/home/wuser/data crow/ubuntu:sshd
```

* The above command will occupy the port 22 of the host. If you woudl like to reserve the port you can use "-P" instead of "-p 22:22"
* In order to develop your code inside the environemnt, the `${PWD}` folder will be mounted to /home/wuser/data. Of course, you can change it by yourself. Or, you can use various ways, e.g., volume data.

## Internal Account

The username is `wuser` and the password is `sshserver`. You can use this account to login to the Container.

## CMakefile reference

The below reference shows if the header file of the googletest package is located in `/usr/local/include/`, you need to tell where they are in the `CMakefile.txt`.

```
target_include_directories(${PROJECT_NAME} 
    PUBLIC
        /usr/local/include/
        ...
)
```

When the system has installed `googletest` package, you can use the methods below to tell your project where to find the library.

```
# for gtest
add_library(libgtest STATIC IMPORTED)
set_target_properties(libgtest PROPERTIES IMPORTED_LOCATION /usr/local/lib/libgtest.a)
set_target_properties(libgtest PROPERTIES INTERFACE_INCLUDE_DIRECTORIES /usr/local/include)

# for gtest_main
add_library(libgtest_main STATIC IMPORTED)
set_target_properties(libgtest_main PROPERTIES IMPORTED_LOCATION /usr/local/lib/libgtest_main.a)
set_target_properties(libgtest_main PROPERTIES INTERFACE_INCLUDE_DIRECTORIES /usr/local/include)

target_link_directories(${PROJECT_NAME} INTERFACE /usr/local/lib)
target_link_libraries(${PROJECT_NAME} gtest gtest_main)
```

Because `cmake` suggests not to use `target_link_directories`. So, you can consider use the way below.

```
find_library(LIBGTEST libgtest.a)
find_library(LIBGTEST_MAIN libgtest_main.a)
target_link_libraries(${PROJECT_NAME} PRIVATE ${LIBGTEST} ${LIBGTEST_MAIN})
```
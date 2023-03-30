# Post, Get, Multipart Request Examples for WRK Http Benchmark tool

>To use the [wrk](https://github.com/wg/wrk) application, information is given for wrk ubuntu installation and installation as a docker container.This repository contains a sample lua script that shows you how to use lua script with wrk. With the help of the sample script you can make multipart and post requests with wrk.

## Installation of wrk on Ubuntu

```bash
  sudo apt-get install build-essential libssl-dev git -y 
```
```bash
  git clone https://github.com/wg/wrk.git wrk
```
```bash
  cd wrk
```
```bash
  sudo make
```
Move the executable to somewhere in your PATH, ex:
```bash
  sudo cp wrk /usr/local/bin
```

## Usage
```bash
git clone https://github.com/Bariskau/wrk-http-benchmark-lua-script-example.git
```
```bash
cd wrk-http-benchmark-lua-script-example
```
```bash
wrk -t4 -c50 -d10s -s post.lua http://127.0.0.1:8080/index.html
```
Can get method value with env
```bash
env method="get" \ 
wrk -t4 -c50 -d10s -s post.lua \
http://127.0.0.1:8080/index.html
```

### Usage with Docker
```bash
 docker build -f Dockerfile -t wrk-example .
```
```bash
docker run --rm -e method="get" wrk-example:latest -t1 -c1 -d5s -s post.lua
 ```
You can add volume to update your files and lua script content
```bash
docker run --rm -v $(pwd):/data/ wrk-example:latest -t1 -c1 -d5s -s post.lua
 ```
### Example Multipart Request
```lua
multipartRequest = function()
    local imgPath = "./lena_gray.jpeg"
    local file = io.open(imgPath, "rb")
    local image = file:read("*all")
    file:close()

    local headers = {
        ["Accept"] = "application/json",
        ["Content-Type"] = "multipart/form-data; boundary=----WebKitFormBoundaryG03anzeS7UA26gFA",
    }

    local imagePart = "------WebKitFormBoundaryG03anzeS7UA26gFA\r\n" ..
            "Content-Disposition: form-data; name=\"image\"; filename=\"lena_gray.jpeg\"\r\n" ..
            "Content-Type: image/jpeg\r\n\r\n" ..
            image .. "\r\n"

    local namePart = "------WebKitFormBoundaryG03anzeS7UA26gFA\r\n" ..
            "Content-Disposition: form-data; name=\"name\"\r\n\r\n" ..
            "john\r\n"

    local surnamePart = "------WebKitFormBoundaryG03anzeS7UA26gFA\r\n" ..
            "Content-Disposition: form-data; name=\"surname\"\r\n\r\n" ..
            "doe\r\n"

    local body = imagePart .. namePart .. surnamePart ..
            "------WebKitFormBoundaryG03anzeS7UA26gFA--\r\n"

    return wrk.format("POST", "/api/v1/add-photo", headers, body)
end
```

## Wrk parameters
 - -s = Lua Script

 - -c = Connection

 - -t = Thread

 - -d10s = Second

> When a browser is assumed to open only one connection, 50 **connections** can be thought of as 50 "users." The total number of connections (-c50) is distributed equally among **threads** (-t4). Generally, the number of threads should be **equal to the number of CPU cores** that wrk is intended to use.
  
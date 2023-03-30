method = os.getenv("method")

-- determines which method to request with
if not method then
    method = "get"
end

getRequest = function()
    local headers = {
        ["Content-Type"] = "application/json",
        ["Accept"] = "application/json",
    }
    return wrk.format("GET", "/api/v1/get", headers)
end

postRequest = function()
    local headers = {
        ["Content-Type"] = "application/json",
        ["Accept"] = "application/json",
    }
    local body = '{"name":"john","surname":"doe"}'
    return wrk.format("POST", "/api/v1/search", headers, body)
end

multipartRequest = function()
    --[[
        Keeping image data as text takes a lot of space.
        Reads the image file from outside
        Also, it doesn't make sense to read the file on every request,
        it negatively affects performance. Read file outside the function
    --]]
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

-- Keeps requests in a table
requests = {
    get = getRequest,
    post = postRequest,
    multipart = multipartRequest
}

-- Determines which endpoint the request will be made to
request = function()
    return requests[method]()
end

--[[
    Shows response if there is an error
    Response is not parse because the cost is too large
--]]
response = function(status, headers, body)
    if status >= 400 then
        io.write("------------------------------\n")
        io.write("Response with status: " .. status .. "\n")
        io.write("------------------------------\n")
        io.write("[response] Body:\n")
        io.write(body .. "\n")
    end
end

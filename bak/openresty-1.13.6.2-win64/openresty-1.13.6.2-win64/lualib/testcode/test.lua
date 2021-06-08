local uri_args = ngx.req.get_uri_args()
local productId = uri_args["id"]

local cache_ngx = ngx.shared.my_cache

local productCacheKey = "user_info_"..productId

local productCache = cache_ngx:get(productCacheKey)

if productCache == "" or productCache == nil then
	local http = require("resty.http")
	local httpc = http.new()

	local resp, err = httpc:request_uri("http://127.0.0.1:5000",{
  		method = "GET",
  		path = "/user/"..productId,
      keepalive=false
	})

	productCache = resp.body
	cache_ngx:set(productCacheKey, productCache, 1 * 60)
end

local cjson = require("cjson")
local productCacheJSON = cjson.decode(productCache)

local context = {
	userId = productCacheJSON.userId,
	userName = productCacheJSON.userName,
	userGender = productCacheJSON.userGender,
  userBirthday = productCacheJSON.userBirthday
}

local template = require("resty.template")
template.render("user.html", context)
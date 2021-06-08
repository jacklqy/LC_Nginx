--用于接收前端数据的对象
local args=nil
--获取前端的请求方式 并获取传递的参数   
local request_method = ngx.var.request_method
--判断是get请求还是post请求并分别拿出相应的数据
if"GET" == request_method then
        args = ngx.req.get_uri_args()
elseif "POST" == request_method then
        ngx.req.read_body()
        args = ngx.req.get_post_args()
        --兼容请求使用post请求，但是传参以get方式传造成的无法获取到数据的bug
        if (args == nil or args.data == null) then
                args = ngx.req.get_uri_args()
        end
end

--获取前端传递的name值
local name = args.name
--响应前端
ngx.say("hello:"..name)

---
title: Json & Ajax
date: 2020-04-11 01:07:13
tags:
---

一.JSON
1.1 JSON概述
Javascript对象表现形式(JavaScript Object Notation)

JavaScript对象表现形式
```js
let user = {“username”:”ObjName”,”age”:”10”,”gender”:”male/female”};
let product = {“Brander”:”Apple”,”Price”:”8999”};
```
取代厚重XML,比起XML更小更快更易解析

Json,XML作用:作为数据的载体，在网络中传输

1.2 JSON基础语法
```js
对象类型
{name:value,name:value}

数组类型

[
{name:value,name:value},
{name:value,name:value},
{name:value,name:value}
]

复杂对象:

{
name:value,
array:[{name:value},{},{}],
user:{name:value}
}


<script>
    //1.描述用户对象
    let user = {"username": "Trump", "Gender": "male", "Age": "103"}
    alert(typeof user);//object
    alert(user.username + user.Gender + user.Age);

    //2.描述用户数组
    let users = [
        {"username": "John", "Gender": "male", "Age": "103"},
        {"username": "Jack", "Gender": "Female", "Age": "23"},
        {"username": "Bobe", "Gender": "male", "Age": "13"}
    ]

    for (let user of users) {
        console.log(user.username + "," + user.Gender + "," + user.Age);
    }

    //3.描述复杂对象
    let Emperor = {
        "Age": 20,
        "Wife": [
            {"username": "Queen", "Gender": "Female", "Age": "23"},
            {"username": "Concubine", "Gender": "Female", "Age": "18"}
        ],
        "Father_Emperor": {"username": "Lord"}
    }
    console.log(Emperor);
    console.log(Emperor.Age);
    let wifes = Emperor.Wife;
    for(let wife of wifes){
        console.log(wife.username + "," + wife.Gender + "," + wife.Age);
    }
    
    let fatherEmperor = Emperor.Father_Emperor;
    console.log(fatherEmperor.username);
</script>
```
1.3 JSON格式转换
JSON对象与字符串的相关函数
语法:
语法	作用
JSON.stringify(object)	把JSON对象转换为字符串
JSON.parse	把字符串转换为JSON对象
```js
<body>
<script>
    let user = {"username": "Trump"}
    alert(typeof user);//object

    let userstr = '{"username": "Trump"}'
    alert(typeof userstr);//string

    //1. JSON.parse 把字符串转换为JSON对象
    let user_parse = JSON.parse(userstr);
    console.log(typeof user_parse);//object

    //2. JSON.stringify(object) 把JSON对象转换为字符串
    let user_stringify = JSON.stringify(user);
    console.log(typeof user_stringify);//string
</script>
</body>
```
二.AJAX
2.1 AJAX概述
AJAX是浏览器提供的一套方法，在无需重新加载整个网页的情况下，能够更新部分网页技术，从而提高用户浏览器网站应用的体验
应用场景

搜索框提示
表单数据验证
无刷新分页

2.2 JS原生AJAX
代码实现
•创建Ajax对象
let xhr = new XMLHttpRequest();
•告诉Ajax请求方式和请求地址
xhr.open(请求方式,请求地址)

•发送请求
xhr.send();

•获取服务器返回的数据
xhr.onload=function(){
xhr.responseText;
}

```js
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <style>
        span{
            color: red;
        }
    </style>
</head>
<body>
<input type="text" id="username" placeholder="Input Username"><span id="userwarn"></span>

<script>
    document.getElementById('username').onblur = function () {
        console.log(this.value);
        //创建Ajax对象
        let xhr = new XMLHttpRequest();

        //告诉Ajax请求方式和请求地址
        xhr.open('get', 'http://localhost:8080/check?username=' + this.value);

        //发送请求
        xhr.send();

        //获取服务器返回的数据
        xhr.onload = function () {
            console.log(xhr.responseText);      //返回的字符串
            document.getElementById('userwarn').innerText=xhr.responseText;
        }
    }
</script>
</body>
```
2.3 jQuery的Ajax插件
2.3.1 ajax函数
语法:
$.ajax(json对象格式);
参数:
url:请求地址
type:请求方式(get:不安全且大小有限制,post大小无限制且相对安全)
data:请求参数
success:请求成功时，执行回调函数
error:请求失败时,执行的回调函数
dataType:预期服务器返回的数据类型:text,json

```js
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script type="text/javascript" src="../js/jquery-3.2.1.js"></script>
    <style>
        span{
            color: red;
}
    </style>
</head>
<body>
<input type="text" id="username" placeholder="Input Username"><span id="userwarn"></span>

<script>
    //给文本绑定失去焦点事件
    $('#username').blur(function () {
        //使用ajax发送请求
        $.ajax({
            url: "http://localhost:8080/check",
            type: "post",
            data: "username=" + $(this).val(),
            success: function (resp) {
                //实现局部刷新
                $('#userwarn').text(resp);
            },
            error: function () {
                alert('Server Busy ,Please Retry');
            },
            //dataType: "json"//相当于把字符串转为JSON对象
        })
    })
</script>
</body>
```
2.3.2 get函数
语法:
$.get(url,callback)
参数:
url:请求地址
success:请求地址成功时的回调函数
```js
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script type="text/javascript" src="../js/jquery-3.2.1.js"></script>
    <style>
        span{
            color: red;
}
    </style>
</head>
<body>
<input type="text" id="username" placeholder="Input Username"><span id="userwarn"></span>

<script>
    //给文本绑定失去焦点事件
    $('#username').blur(function () {
        //使用get发送函数
        let url = 'http://localhost:8080/check?username' + $(this).val();
        $.get(url, function (resp) {
            //局部刷新
            $('#userwarn').text(resp);
        })
    })
</script>
</body>
```
2.3.3 post函数
语法:
$.post(url,data,success)
参数:
url:请求地址
data:请求参数
success:请求地址成功时的回调函数
```js
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script type="text/javascript" src="../js/jquery-3.2.1.js"></script>
    <style>
        span{
            color: red;
}
    </style>
</head>
<body>
<input type="text" id="username" placeholder="Input Username"><span id="userwarn"></span>

<script>
    //给文本绑定失去焦点事件
    $('#username').blur(function () {
        //使用post发送函数
        let url = 'http://localhost:8080/check';
        let data = 'username=' + $(this).val();
        $.post(url, data, function (resp) {
            //局部刷新
            $('userwarn').text(resp);
        })
    })
</script>
</body>
```
2.4 同步和异步概述
使用ajax发送的是异步请求
**同步和异步请求指的是:客户端和服务器的交互行为
同步:客户端发送请求后，必须等待服务器端响应。在等待的期间客户端不能做其他操作
异步:客户端发送请求后，不需要等待服务器端的响应。在服务器处理的过程中，客户端可以进行其他操作

感知同步和异步区别:

```js
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script type="text/javascript" src="../js/jquery-3.2.1.js"></script>
</head>
<body>
<button id="btn">Send Ajax</button>

<script>
    //给按钮绑定事件
    $('#btn').click(function () {
        // 使用ajax函数发送请求，ajax默认的是异步提交，可以改为同步(了解)
        $.ajax({
            url: 'http://localhost:8080/sleep',
            type: 'get',
            success: function (resp) {
                alert(resp)
            },
            async: false // 同步提交
        })
    })
</script>
</body>
```
三.搜索案例
```js
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Search Case</title>
    <script type="text/javascript" src="../js/jquery-3.2.1.js"></script>
    <style type="text/css">
        .content {
            width: 643px;
            margin: 200px auto;
            text-align: center;
        }

        input[type='text'] {
            width: 530px;
            height: 40px;
            font-size: 14px;
        }

        input[type='button'] {
            width: 100px;
            height: 46px;
            background: #38f;
            border: 0;
            color: #fff;
            font-size: 15px
        }

        .show {
            position: absolute;
            width: 535px;
            height: 100px;
            border: 1px solid #999;
            border-top: 0;
        }
    </style>
</head>
<body>
<div class="content">
    <img src="../img/logo.png" alt=""><br/><br/>
    <input type="text" id="search" name="keyword">
    <input type="button" value="Search">
    <div class="show" style="display: none"></div>
</div>

<script>
    //1.搜索框绑定键盘弹起事件
    $('#search').keyup(function () {
        //显示div
        $('.show').show();

        //2.获取用户输入的值
        console.log($(this).val());
        //判断用户输入的值，JS提供了trim()方法,JQ使用需要转换
        if (this.value.trim().length == 0) {
            return $('.show').hide();//拦截代码，不再向下执行
        }

        //3.使用post函数发送请求
        let url = 'http://localhost:8080/search';
        let data = 'keyword=' + $(this).val();
        $.post(url, data, function (resp) {
            //清空上次搜索的内容
            $('.show').empty();
            //4.局部更新
            console.log(resp);
            for (let ele of resp) {
                $('.show').append(`<div style="cursor: pointer;
                                        text-align: left;
                                        padding-left: 5px"
                                        onmouseover="highlight(this)"
                                        onmouseout="restores(this)"
                                        onclick="set(this)">${ele}</div>`)
            }
        })
    })

    function highlight(obj) {
        $(obj).css('background-color', '#f0f0f0');
    }

    function restores(obj) {
        $(obj).css('background-color', 'white');
    }

    function set(obj) {
        //设置选中文字色
        $('#search').val($(obj).text()).css('color','brown');
        //跳转网址
        location.href = "http://www.baidu.com";
        // $('.show').css('display', "none");
        $('.show').hide();
    }
</script>
</body>
</html>
```
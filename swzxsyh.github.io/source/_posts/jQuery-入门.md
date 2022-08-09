---
title: jQuery 入门
date: 2020-04-10 01:05:53
tags:
---

一.jQuery概述
1.1 简介
jQuery是一个优秀的javascript的轻量级框架之一，封装了dom操作、事件、页面动画、异步操 作等功能。
特别值得一提的是基于jQuery的插件非常丰富，大多数2015年之前的前端业务场景都有其封装好的工具框架。

注意:如果公司使用的老版本插件，升级jQuery之后，可能会让插件失效

库名	说明
jQuery-x.js	开发版本:有良好的锁紧格式和注释，方便开发者阅读
jQuery-x.min.js	生产版本:代码进行压缩,体积小方便网络传输
1.2 自定义JS框架
框架(Framework)是完成某种功能的半成品，抽取重复繁琐代码，提高简介强大的方法实现。

感知jQuery的强大

1
2
3
4
5
// 抽取获取id的方法 function jQuery(id) {
return document.getElementById(id); }
// 简化名称方案 function $(id) {
return document.getElementById(id); }

1
2
3
4
5
6
7
8
9
10
11
12
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script type="text/javascript" src="../js/itcast.js"></script>
</head>
<div id="myDiv">AAAAAAAAAA</div>
<script>
    //通过JS原生方式
    // document.getElementById("myDiv").innerHTML = "CCCCCC";

    $('myDiv').innerHTML = 'ZZZZZ';
</script>
小结:jQuery本质上就是js的一个类库文件，使用它时，就能简化代码

二.jQuery基础语法
2.1 HTML引入jQuery
1
2
3
4
5
6
7
8
9
10
11
12
<head>
    <meta charset="UTF-8">
    <title>HTML Intro Jqurey</title>
    <script type="text/javascript" src="../js/jQuery-3.2.1.js"></script>
</head>
<body>
<div id="myDIV">AAAAAAAAAA</div>
<script>
    //获取div标签的js对象
    $('#myDIV').html("XXXXXX");
</script>
</body>
2.2 jQuery与JS区别
jQuery虽然本质也是JS，但是如果使用jQuery的属性和方法那么必须包装对象是jQuery对象而不是js对象。
通过js方式获取的是js对象，通过jQuery方式获取的是jQuery对象，两者关系和区别如下:

jQuery与JS的相互转换
js—>jq
$(js对象)或者jQuery(js对象)
jq—>js
js对象[] 或者 jq对象.get(索引)
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
<head>
    <meta charset="UTF-8">
    <title>Mutual conversion</title>
    <script type="text/javascript" src="../js/jQuery-3.2.1.js"></script>
</head>
<body>
<div id="myDiv">AAAAA</div>
<script>

    // 通过js方式修改文本内容
    let myDiv=document.getElementById('myDiv');
    myDiv.innerHTML='AAAAAAAAA';

    //通过jQuery方式修改文本内容
    let $myDiv = $('#myDiv');
    // $myDiv.html('XXXXXXXXX');

    //js对象和jQuery对象的 - 属性和方法不通用
    // myDiv.html('js操作jq函数');
    // $myDiv.innerHTML='jq 操作 js 属性'

    //JS对象——转换为JQ对象
    $(myDiv).html('JS convert to JQ');

    //JQ对象——转换为JS对象
    //注意:jq对象本质上是js数组，数组的每一个元素就是js原生对象
    console.log($myDiv.length);
    $myDiv[0].innerHTML='jQuery convert to JavaScript OB';
</script>
</body>
页面加载事件
js
window.onload=function(){}

jq
$(function(){})

区别
js:只能定义因此，如果定义多次，后加载会进行覆盖
jq:可以定义多次

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
<head>
    <meta charset="UTF-8">
    <title>window onload</title>
    <script type="text/javascript" src="../js/jQuery-3.2.1.js"></script>
</head>
<body>
<script>
    //js页面加载事件
    // window.onload = function () {
    //     alert('js on load');
    // }

    //jq页面加载事件
    $(function () {
        alert('jq on load 1')
    })

    $(function () {
        alert('jq on load 2')
    })
</script>
三.jQuery选择器
3.1 基本选择器
标签(元素)选择器
语法:
$(“html标签名”) 根据标签匹配元素 格式 标签
id选择器
语法:
$(“#id的属性值”) 根据id值匹配元素 id属性是标签的唯一标志 #id
类选择器
语法:
$(“.class的属性值”) 根据class的值匹配元素 class属性是给标签归类添加样式 格式 .class
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
<body>
<span class="female">古力娜扎</span>
<span class="female">迪丽热巴</span>
<span class="female hero">黑寡妇</span>

<span class="male hero">钢铁侠</span>
<span class="male hero">超人</span>
<script>
    //1.获取span标签的jQuery对象
    console.log($('span'));
    //2.获取class有hero的jQuery对象
    console.log($('.hero'));
    //获得id="boss"的jQuery对象
    console.log($('#boss'));
</script>
</body>
3.2 层级关系选择器
后代选择器
语法:
$(“A B”) 选择A元素内部的所有B元素
并集选择器
语法:
$(“选择器1,选择器2….”) 获取多个选择器选中的所有元素
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
<body>
<div id="kangxi">
    <span>儿子：雍正</span>
    <p>
        <span>孙子：乾隆</span>
    </p>
</div>
<div>牛顿</div>

<script>
    // 1. 获取所有的p,div的文本
    console.log($('p,div').text());
    // 2. 获取div的后代span的文本
    console.log($('#kangxi span').text);
</script>
3.3 属性选择器
属性选择器
语法:$(“A[属性名=’值’]”) 包含指定属性等于指定值的选择器
复合属性选择器
语法:$(“A[属性名=’值’][]…”) 包含多个属性条件的选择器
1
2
3
4
5
6
7
8
9
10
11
12
<body>
<input type="text" name="username" value="用户名"/><br/>

<input type="text" name="nickname" value="昵称"/><br/>

<script>
    // 1.获取type='text'的input标签
    console.log($('input[type="text"]'));
    // 2.获取type='text' 且 name="nickname" 的input标签
    console.log($('input[type="text"][name="nickname"]'));
</script>
</body>
3.4 过滤选择器
首元素选择器
语法: :first 获得选择的元素中的第一个元素
尾元素选择器
语法: :last 获得选择的元素中的最后一个元素
偶数选择器
语法: :even 偶数，从 0 开始计数
奇数选择器
语法: :odd 奇数，从 0 开始计数
指定索引选择器
语法: :eq(index) 指定索引元素
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
<body>
<ul>
    <li>大娃（红娃）</li>
    <li>二娃（橙娃）</li>
    <li>三娃（黄娃）</li>
    <li>四娃（绿娃）</li>
    <li>五娃（青娃）</li>
    <li>六娃（蓝娃）</li>
    <li>七娃（紫娃）</li>
</ul>

<script>
    // 获得所有li标签，在此基础上进行筛选过滤
    // 1.获取第一个元素
    console.log($('li:first').text());
    //获取最后一个元素
    console.log($('li:last').text());

    // 2.获取偶数索引元素
    console.log($('li:even').text());
    // 获取奇数索引元素
    console.log($('li:odd').text());

    // 3.获取指定索引2的元素
    console.log($('li:eq(2)').text());
</script>
3.5 对象遍历
语法
jq对象.each(function(index,element){
})

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
<body>
<!--
jQuery对象的遍历
    $.each() 用法示例
-->
<ul id="city">
    <li>北京</li>
    <li>上海</li>
    <li>天津</li>
</ul>

<script>
    let lis = document.querySelectorAll('li');

    //普通for
    for(let i=0;i<lis.length;i++){
        console.log(lis[i]);
    }
    //增强for
    for (let li of lis) {
        console.log(li);
    }
    console.log("=========");
    //jQuery的for循环
    $('li').each(function (index,element) {
        console.log(index);
        console.log(element);//遍历的元素是js对象
        console.log(element.innerHTML);
        console.log($(element).html());//升级为jQuery对象
        console.log(this);//当前遍历的元素,相当于element
    })
</script>
</body>
四.jQuery的DOM操作
4.1 jQuery操作内容
text():获取/设置元素的标签体纯文本内容
相当于js: innerText属性
html():获取/设置元素的标签体超文本内容
相当于js: innerHTML属性
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
<body>
<div id="myDiv"><p>天王盖地虎</p></div>
<script>
    // 1.text()操作内容
    //1.1 获得纯文本内容
    console.log($('#myDiv').text());
    //设置纯文本内容
    console.log($('#myDiv').text('<h1>宝塔镇河妖</h1>'));

    // 2.html()操作内容
    //2.1 获取超文本内容
    console.log($('#myDiv').html());

    //2.2 设置超文本内容
    $('#myDiv').html($('#myDiv').html()+'<h1>宝塔</h1>');
    
</script>
</body>
4.2 jQuery操作属性
val():获取/设置元素的value属性值
相当于:js对象.value
attr():获取/设置元素的属性
removeAttr() 删除属性
相当于:js对象.setAttribute() / js对象.getAttribute()
prop():获取/设置元素的属性
removeAttr() 删除属性
jq在1.6版本之后，提供另一组API prop 通常处理属性值为布尔类型操作
例如:checked selected等
做条件判断用prop，做属性封装做attr

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
<body>
<form action="#" method="get">
    姓名 <input type="text" name="username" id="username" value="德玛西亚"/> <br/>

    爱好
    <input id="hobby" type="checkbox" name="hobby" value="perm" checked="checked">烫头<br/>
    <input id="hobby_undefined" type="checkbox" name="hobby" value="perm" >烫头<br/>


    <input type="reset" value="清空按钮"/>
    <input type="submit" value="提交按钮"/><br/>
</form>

<script>
    // 1.获取文本框value属性
    //方式一:
    console.log($('#username').attr("value"));//查看
    $('#username').attr('value', 'abc');//新增 or 修改
    $('#username').removeAttr('value');//删除

    //方式二:
    console.log($('#username').val());
    $('#username').val('BBC');

    // 2.获取爱好的checked属性
    /*
    方式一:使用attr获取复选框状态
      该按钮选中返回:checked
      未选中返回:undefined
    */
    console.log($('#hobby').attr('checked'));
    console.log($('#hobby_undefined').attr('checked'));

    //方式二:使用val获取复选框状态
    /*
    jq在1.6之后弥补了设计缺陷,如果该属性存在返回true,不存在返回false
    */
    console.log($('#hobby').prop('checked'));
    console.log($('#hobby_undefined').prop('checked'));
</script>
</body>
4.3 jQuery操作样式
直接修改jq对象样式属性
语法:
jq对象.css()
css(样式名) 获取
css(样式名,样式值) 设置
优点:支持css语法
举例:font-size

添加/删除jq对象样式
语法:
jq对象.addClass()
jq对象.removeClass()

切换jq对象样式
语法:
jq对象.toggleClass() 无添加，有删除

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script type="text/javascript" src="../js/jquery-3.2.1.js"></script>
    <style>
        #p1 {
            background-color: red;
        }

        .mp {
            color: green;
            border: 2px blue;
        }

        .mpp {
            background-color: lightgray;
        }
    </style>
</head>
<body>
<p id="p1">1. 设置一个css样式</p>
<p id="p2">2. 批量设置css样式</p>
<p id="p3">3. 通过class设置样式</p>
<p id="p4">4.
    <button id="toggle">切换</button>
    class样式
</p>
<script>
    let $p1 = $('#p1');//获取p1
    let $p2 = $('#p2');//获取p2
    let $p3 = $('#p3');//获取p3
    let $p4 = $('#p4');//获取p4

    //0.获取单元格标签的背景色
    console.log($p1.css('background-color'));
    // 1. 设置一个css样式
    $p1.css('background-color', 'gray');
    // 2. 批量设置css样式
    $p2.css({'border': '1px solid red', 'font-size': '20px'});
    // 3. 通过class设置样式
    $p3.addClass('mp mpp');
    $p3.removeClass('mpp');

    // 4. toggleClass() 切换一个class
    $('#toggle').click(function () {
        $p4.toggleClass('mp') })
</script>
</body>
4.4 jQuery操作元素
$(标签) 创建一个标签
例:
1
$('<li>xxx</li>')
$.prepend() 在父标签中将子标签放在第一个位置
$.append() 在父标签中将子标签放在最后一个位置
$.empty() 清空子元素
$.remove() 删除自己
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
<body>
<ul id="star">
    <li>古力娜扎</li>
    <li>迪丽热巴</li>
</ul>

<script>
    let $star = $('#star'); // 无序列表
    // 1.前面添加马尔扎哈
    console.log($('<li>马尔扎哈</li>'));
    $star.prepend($('<li>马尔扎哈</li>'));

    // 2.后面添加萨瓦迪卡
    $('#star').append($('<li>萨瓦迪卡</li>'));

    // 3.移出所有列表项
    $('#star').empty()
    // 4.删除无序列表
    $star.remove();
</script>
五.jQuery事件绑定
js对象.事件属性=function(){}
jq对象.事件函数(function(){})

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
<body>
<input type="button" value="js方式" id="jsBtn"> <br>
<input type="button" value="jq方式" id="jqBtn"> <br>

<script>
    //js事件绑定
    document.getElementById('jsBtn').onclick = function () {
        alert('JS Bind Event');
    }

    //jq事件绑定
    $('#jqBtn').click(function () {
        alert('JQ Bind Event');
    })
</script>
</body>
额外拓展
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script type="text/javascript" src="../js/jquery-3.2.1.js"></script>
    <style>
        div {
            width: 100px;
            height: 100px;
            background-color: skyblue;
        }
    </style>
</head>
<body>
<div id="div1">

</div>
<script>
    $('#div1').mouseover(function () {
        //可以使用this，但this是js的原生对象，需要升级成jq对象
        $(this).css({'background-color':'pink'});
    }).mouseout(function () {
        $(this).css({'background-color':'skyblue'});
    })
</script>
</body>
六.综合案例
6.1 隔行换色
1
2
3
4
<script>
    $('tr:gt(0):even').css('background-color','lightgray');
    $('tr:gt(0):odd').css('background-color','skyblue');
</script>
6.2 商品全选
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
<script>
    $('#btn1').click(function () {
        $('input[type="checkbox"]').prop('checked', true);
    })

    $('#btn2').click(function () {
        $('input[type="checkbox"]').each(function (index,element) {
            //js方式
            element.checked = !element.checked;
            //jq方式
            // $(element).prop('checked', !$(element).prop("checked"));
        })
    })

    $('#btn3').click(function () {
        $('input[type="checkbox"]').prop('checked', false);
    })

</script>
6.3 QQ表情
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47

<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <meta charset="UTF-8" />
    <title>QQ表情选择</title>
    <style type="text/css">
        *{margin: 0;padding: 0;list-style: none;}

        .emoji{margin:50px;}
        ul{overflow: hidden;}
        li{float: left;width: 48px;height: 48px;cursor: pointer;}
        .emoji img{ cursor: pointer; }
    </style>
    <script type="text/javascript" src="../js/jquery-3.2.1.min.js"></script>
</head>
<body>
<div class="emoji">
    <ul>
        <li><img src="../img/01.gif" height="22" width="22" alt=""/></li>
        <li><img src="../img/02.gif" height="22" width="22" alt=""/></li>
        <li><img src="../img/03.gif" height="22" width="22" alt=""/></li>
        <li><img src="../img/04.gif" height="22" width="22" alt=""/></li>
        <li><img src="../img/05.gif" height="22" width="22" alt=""/></li>
        <li><img src="../img/06.gif" height="22" width="22" alt=""/></li>
        <li><img src="../img/07.gif" height="22" width="22" alt=""/></li>
        <li><img src="../img/08.gif" height="22" width="22" alt=""/></li>
        <li><img src="../img/09.gif" height="22" width="22" alt=""/></li>
        <li><img src="../img/10.gif" height="22" width="22" alt=""/></li>
        <li><img src="../img/11.gif" height="22" width="22" alt=""/></li>
        <li><img src="../img/12.gif" height="22" width="22" alt=""/></li>
    </ul>
    <p id="word">
        <strong>请发言：</strong><!-- 给文本加粗 -->
        <img src="../img/12.gif" height="22" width="22" alt=""/>
    </p>
</div>

<script>
    //给所有图片绑定点击事件
    $('.emoji img').click(function () {
        //this表示当前image标签
        $('#word').append($(this).clone());
    })
</script>
</body>

总结:
Jquery概述
jQuery是一个优秀的javascript的轻量级框架
Jquery基础语法
HTML引入Jquery
jQuery与JS区别
jQuery对象与js对象相互转换

$(js对象) 或 jQuery(js对象)
jq对象(索引) 或 jq对象.get(索引)
页面加载事件

window.onload=function(){}

只能定义一次
$(function(){})

可以定义多次
Jquery选择器
1 基本选择器
$(“html标签名”)
$(“#id的属性值”)
$(“.class的属性值”)
2 层级选择器
$(“A B”)
$(“选择器1,选择器2….”)
$(“A > B”)
3 属性选择器
$(“A[属性名=’值’]”)
$(“A[属性名=’值’][]…”)
4 基本过滤选择器
:first
:last
:even
:odd
:eq(index)
5 对象遍历
jq对象.each(function(index,element){})
Jquery的DOM操作
Jquery操作内容
html()

超文本
text()

纯文本
Jquery操作属性
val()

操作value属性
attr()

removeAttr()
prop()

removeProp()

checked
selected
Jquery操作样式
jq对象.css()

jq对象.addClass()

jq对象.removeClass()
Jquery操作元素
$(““)

创建jq标签对象
prepend()

父添加子，放在一个位置
append()

父添加子，放在最后一个
remove()

灭门
empty()

断子绝孙脚
Jquery事件绑定
js对象.事件属性=function(){}
jq对象.事件函数(function(){})
综合案例
隔行换色
商品全选
QQ表情
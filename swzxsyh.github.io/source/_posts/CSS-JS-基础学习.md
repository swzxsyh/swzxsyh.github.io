---
title: CSS & JS 基础学习
date: 2020-04-05 01:02:30
tags:
---

一.CSS概述
层叠样式表
作用：美化页面
层叠样式：对同一个标签添加多个不同对样式，所有的样式会叠加在一起显示出效果

优点:
•实现了样式和内容对分离，提高了显示效果和样式的复用性
•降低耦合性，分工更加明确，CSS专门用于美化，HTML专门用于结构搭建

```css
<style>
    span{
        font-size: 50px;
        color: blueviolet;
        border: 1px solid skyblue;
    }
</style>
<head>
    <meta charset="UTF-8">
    <title>CSS & JS</title>
</head>
<body>
    <span>AAAAAAAAAAA </span><br>
    <span>BBBBBBBBBBB </span><br>
    <span>CCCCCCCCCCC </span>
</body>
```
二.CSS基础语法
2.1 HTML引入CSS
```css
<head>
    <meta charset="UTF-8">
    <title>Introduce CSS</title>

    <!--内部样式-->
    <style type="text/css">
        h1{
            color: blue;
        }
    </style>

    <!-- 外部样式  -->
    <link rel="stylesheet" href="MyCSS.css">

</head>
<body>
    <!--
    HTML引入CSS的三种方式
    1)行内样式
        语法:<h1 style="CSS样式"><h1>
        作用范围:当前标签范围
    2)内部样式:使用style标签
        语法:<style type="text/css"></style>
            type="text/css"告知浏览器把解析器切换成CSS类型
        作用范围:当前页面
    3)外部样式:
        使用link标签引入外部CSS样式
        语法:<link rel="stylesheet" href="外部CSS文件地址" />
            rel="stylesheet" 告知浏览器引入的文件类型是CSS样式表
        作用范围:所有引入的html页面


     CSS样式优先级:就近原则，浏览器的执行顺序自上而下
     CSS样式引入推荐放在head头部
    -->

    <!-- 行内样式       -->
    <h1 style="color: red">A</h1>
    <h1>B</h1>
    <h1>C</h1>
</body>
```
2.2 CSS属性规范
```css
<style>
    /*
    css注释内容
    css语法:
        选择器(css样式)
        css样式格式:{样式名:样式值:样式名:样式值}

    
    样式名多个单词用横杠分隔
    样式值多个单词用空格分隔
    多个样式之间，以分号分隔
    */
    span{
        color: gray;/*字体颜色*/
        font-size: 10px;/*字体大小*/
        border: 2px solid chartreuse;
    }
</style>
```
2.3 基本选择器
```css
<head>
    <meta charset="UTF-8">
    <title>Basic_Selector</title>
    <style>
        /*标签*/
        span{
            color: red;
            font-size: 20px;
        }

        /*class类 选择器*/
        .a{
            color: green;
            font-size: 30px;
        }
        .b{
            color: blue;
            font-size: 40px;
        }
        .z{
            font-weight: bold;
        }

    /*ID选择器*/
        #c{
            color: brown;
        }

    </style>
</head>
<body>
<!--
    选择器:作用选定一组特有的标签
    1)标签
        特点:此名称的所有标签都收到控制
        语法:标签名{css样式}
    2)class(类)
        特点:具有分组特性
        语法.class{css样式}

    3)id
        特点：具有唯一性
        语法: #id{css样式}
        -->
    <span class="a">A</span>
    <span class="a z">A Z</span>
    <span class="a z">A Z</span>

    <span class="b">B</span>
    <span class="b z">B Z</span>
    <span class="b z">B Z</span>

    <span id="c">C</span>
</body>
```
2.4 扩展选择器
```css
<head>
    <meta charset="UTF-8">
    <title>Extra_Selector</title>
    <style>
        p, span {
            font-family: 楷体; /*字体类型*/
        }
        div>span{
            color: red;
        }
        input[type="text"]{
            background-color: cornflowerblue;
        }
    </style>
</head>
<body>
    <!--
        扩展选择器
            1)并集
                语法:选择器1，选择器2...{CSS样式}
            2)后代
                语法:父 子(孙子)
            3)父子
                语法:父>子{css样式}
            4)属性过滤
                语法:选择器[属性名="属性值"]{CSS样式}
            -->
    <div>
        <span>AAAA</span>
        <p>
            <span id="gbl">BBBB</span>
        </p>
    </div>
    <span id="jjx">CCCC</span>
    <label>Name</label>
    <input type="text" name="username" value="Jack">
    <br/>
    <label>Passwd</label>
    <input type="password" name="password" value="123456">
    <br>
</body>
```
三.CSS常用样式
3.1 字体和文本属性
```css
    <style>
        /*
        渲染需求:
            1.所有文字绿色
            2.所有文字大小20px
            3.所有行高40px
            4.所有字体加粗
            5.所有字体楷体
            6.第一句文字倾斜
            7.第一句隐藏下划线
        */
        div p {
            color: green; /*所有文字绿色*/
            font-size: 20px; /*所有文字大小20px*/
            line-height: 40px; /*所有行高40px*/
            font-weight: bold; /*所有字体加粗*/
            font-family: 楷体; /*所有字体楷体*/
        }

        div p a {
            font-style: italic; /*第一句文字倾斜*/
            text-decoration: none; /*第一句隐藏下划线*/
        }
    </style>
</head>
<body>
    <div>
        <p>
            <a href="#">Learn</a><br>
            HTML<br>
            CSS<br>
            Style<br>
        </p>
    </div>
</body>
```
3.3 背景属性
```css
    <style>
        body {
            /*background-color: gray;*/
            /*background-image: url("../img/Danboard.jpg");*/
            /*background-repeat: no-repeat;*/
            background: gray url("../img/Danboard.jpg") no-repeat;
        }

        h1 {
            color: white;
            text-align: center;
        }
    </style>
</head>
<body>
    <!--
    background-color:背景色
    background-image:背景图片
            取值:url('图片地址')
    background-repeat:平铺方式
            取值:repeat(水平和垂直),repeat-x(水平),repeat-y(垂直),no-repeat(不平铺)
    简写方式:
            background:color image repeat;
            -->
    <h1>Sub Title</h1>

</body>
```
3.4 显示属性
```css
<style>
    span,div{
        border: 1px solid red;
    }
    span{
        display: block;/*块级元素*/
    }
    div{
        display: inline;/*行内元素*/
    }
    ul li{
        display: inline;
    }
    #div3{
        display: none;
    }
</style>
<body>
<!--
    显示属性:display
    1)inline:将标签改为行内元素
    2)block:将标签改为块级元素
    3)none:隐藏此标签
        -->
    <span>span1</span>
    <span>span2</span>
    <span>span3</span>
    <div>div1</div>
    <div>div2</div>
    <div id="div3">div3</div>
    <ul>
        <li>A</li>
        <li>B</li>
        <li>C</li>
    </ul>
</body>
```
3.5 浮动属性
打破常规，让div也能变小(实际大小，与宽高有关)
```css
    <style>
        .box {
            width: 150px;
            height: 150px;
            border: red;

        }

        #a {
            float: left;
        }

        #b {
            float: right;
        }

        #both {
            clear: both;
        }
    </style>
</head>
<body>
    <!--
    浮动:float
        取值：left,right
    清楚浮动:clear
       取值:both
            -->
    <div class="box" id="a">AAA</div>
    <div class="box" id="b">BBB</div>
    <div id="both"></div>
    <div class="box">CCC</div>
</body>
```
3.6 盒子属性
```css
    <style>
        .box {
            width: 300px;
            height: 300px;
            border: 10px solid skyblue;
            padding: 10px;
            margin: 10px;
            margin:auto;
            box-sizing: border-box;
        }
    </style>
</head>
<body>
    <!--
        盒子模型:
        1)宽和高
            width:30opx
            height:300px
        2)边框
            border:宽度 类型 颜色
                类型:solid 单线
                     double 双线
                     dashed 虚线
        3)内边距
            padding-top    上
            padding-right   右
            padding-bottom  下
            padding-left    左
          简写:
            padding: 上 右 下 左
        4)外边距
            margin-top     上
            margin-right   右
            margin-bottom  下
            margin-left    左
           简写:
            margin: 上 右 下 左
           特殊:
            margin:auto  水平居中

         5)盒子类型
            box-sizing:content-box(默认)  盒子大小(宽和高+内边距+边框),计算起来麻烦
            box-sizing:border-box盒子大小(宽和高)包含(内边距和边框),计算起来简单

        盒子大小=内容大小+padding+border
            -->
    <div class="box">
        <img src="../img/Danboard.jpg" width="260px" height="260px" alt="">

    </div>
</body>
```
四.JavaScript概述
作用:页面交互

特点:
•JavaScrpit源码不需要编译，浏览器可以直接解释运行
•JavaScrpit是弱类型语言，js变量声明不需要指明类型

组成部分	作用
ECMA Scrpit	构成了JS核心的语法规则
BOM	Browser Object Model浏览器对象模型，用来操作浏览器上的对象
DOM	Document Object Model文档对象模型，用来操作网页中的元素
五.JavaScript基础语法
5.1 HTML引入JS
```css
<body>
    <!--
HTML引入js的两种方式
    1)内部脚本
        语法:<script type="text/javascript">JS Code</script>
    2)外部脚本
        语法:<script src="外部JS文件地址"></script>

    补充:script标签可以在页面任意位置，建议放在body尾部
        页面顺序:css->html->js

    注意:
        1)script标签不能自闭和
        2)如果script标签使用了src属性，那么浏览器将不会解析此标签体的js代码
    -->

    <script type="text/javascript">
        document.write('<h1>This is Inside Script</h1>')
    </script>

    <script src="MyJS.js">
        // document.write('Useless')
    </script>

</body>
```
5.2 JS三种输出方式
```css
<body>
    <!--
    JS三种输出方式:
    1)浏览器弹框输出字符
    2)输出html内容到页面
    3)输出到浏览器控制台
    -->
    <script>
        alert("浏览器弹框输出字符")

        document.write("输出html内容到页面")

        console.log("输出到浏览器控制台")
    </script>
</body>
```
5.3 JS变量声明
JS是弱类型语言，不注重变量的定义，使用在JS中定义变量的类型方式如下
```css
<body>
        <!--
        JS的变量声明:
        ECMAScript 6 之前所有的遍历声明都用var
        ES 6 之后开始退出let声明变量,const声明变量
                -->

        <script>
            let str = "AAA";
            console.log(str);

            let i = 1;
            console.log(i);

            let d = 123.123;
            console.log(d);

            const PI = 3.14;
            console.log(PI);

            //boolean
            let b = true;
            console.log(b)

            //感知弱类型语言不注重变量的定义
            let a;
            console.log(a);
            
            a = 123;
            console.log(a);

            a = true;
            console.log(a);

            a = new Object();
            console.log(a);

        </script>
    </body>
```
5.4 JS数据类型
JS数据类型也分为基本(原始)数据类型和引用数据类型
```css
<body>
    <!--
    基本数据类型:
        1)number 数值(整型,浮点都属于数值)
        2)string 字符串(单引号,双引号),在JS中都是字符串，没有字符概念
        3)boolean 布尔类型(true/false)
        4)undefined 未定义
    引用数据类型:
        let obj = new Object();
        let date = new Date();

    判断变量都数据类型:
        语法:typeof变量名
            -->
    <script>

        //感知弱类型语言不注重变量的定义
        let a;
        console.log(typeof a);

        a = "ABC";
        console.log(typeof a);

        a = 'ABC';
        console.log(typeof a);

        a = 123;
        console.log(typeof a);

        a = 123.123;
        console.log(typeof a);

        a = true;
        console.log(typeof a);

        a=new Object();
        console.log(typeof a);

        let stu = new Object();
        stu.id = 1;
        stu.name = 'a';
        stu.age = 18;
        console.log(stu);
    </script>
</body>
```

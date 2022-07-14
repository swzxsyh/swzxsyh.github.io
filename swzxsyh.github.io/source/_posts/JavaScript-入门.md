---
title: JavaScript 入门
date: 2020-04-06 01:04:39
tags:
---

一.JavaScript基础语法
1.1 JS运算符
算术运算符
+ - * / % ++ –


赋值运算符
= += -= *= /=


比较运算符
```
> < ==(===) !=(!==)
```
逻辑运算符
&& || !


三元(目)运算符
条件表达式?为真:为假

```js


<script>
  //算数运算符
  //在JS中数值可以与字符串进行数学运算，底层实现了隐式转换
  let a =10;//num
let b = '4';//String
console.log(a+b);//104 字符串拼接
console.log(a-b);//6
console.log(a*b);//40
console.log(a/b);//2.5  保留小数位


//比较运算符
let c='10';
console.log(a == c);//比较的是内容
console.log(a === c);//比较的是类型+内容

//!=  比较的是内容
//!== 比较的是类型+内容

</script>
```


1.2 JS流程控制
条件判断
•if判断
if(条件表达式){
代码块
}else if(条件表达式){
代码块
}else{
代码块
}
•switch判断
switch(条件表达式){
case 满足条件1 :
代码块 break;
case 满足条件2 :
代码块 break;
case 满足条件3 :
代码块 break;
}

```js
<script>
  /*
    条件表达式
        1)布尔型
        2)数值型:非0为真
        3)字符串:非空串为真
        4）变量:null 或 undefined 都为假
    */
  let flag = true;
flag = 15;
flag = "Hello";
flag = null;
if(flag){
  console.log("Right");
}else{
  console.log("Wrong");
}
</script>
```

循环语句
•普通for循环
for (let i = 0; i < ; i++) {
//需要执行的代码
}

•增强for循环
for(let obj of array){
//需要执行的代码
}

•索引for循环
for(let index in array){
//需要执行的代码
}

•while循环
while(条件表达式){
//需要执行的代码
}

•do…while循环
do{
//需要执行的代码
}while(条件表达式)

•break和continue
break:跳出整个循环
continue:跳出本次循环

```js
<script>
  let arr=['a','b','c'];


//普通for循环
for (let i = 0; i < arr.length; i++) {
  console.log(arr[i]);
}

//增强for循环
for(let element of arr){
  console.log(element);
}
//索引for循环
for (let index in arr) {
  console.log(index);
  console.log(arr[index]);
}

</script>
```


二.JS函数
功能:js函数用于执行特定功能的代码块，为了方便立即也可以称为JS方法

2.1 普通函数
语法:
function 函数名(参数列表){
函数体;
[return 返回值;] //中括号表示内容可以省略
}

js不支持方法重载，重名的方法会被覆盖

```js
<script>
  //两数求和
  function sum(a, b) {
  //console.log(a + b);   //无返回值
  return a + b;
}
// sum(1,10);

//三数求和
//NaN:not a number 这不是一个数
//js是弱类型语言，不支持方法重载，重名的方法会覆盖
//js函数定义的参数个数，可以与实际调用的参数个数不同
function sum(a, b, c) {
  return a + b + c;
}

let result = sum(1, 5);
console.log(result);

console.log(sum(1, 2, 3));
function new_sum(a, b, c) {
  //js函数题内置arguments[]数组对象，获取实际调用者的参数值
  console.log(arguments[3]);//可以获取额外传入的第4个参数，但是不允许这样使用
}

new_sum(1, 2, 3, 4, 5);

//可变参数,本质就是一个数组
function sum(...args) {
  console.log(args);
}

let resut = sum(5, 6, 7, 8);
// console.log(resut);
```

2.2 匿名函数
通常与事件结合使用
语法:
function (参数列表){
函数体;
[return 返回值;]//中括号表示内容可以省略
}

```html
<body>
  <button id="btn">Button</button>

  <script>
    document.getElementById("btn").onclick = function () {
      alert("匿名函数触发事件");
    };
  </script>

</body>
```


2.3 案例:轮插图
分析:
展示图片的<img src=”1.jpg”/>
通过js代码修改img标签的src数学

每隔3秒，切换一次，使用定时器

通过定时器，触发一个方法，修改img标签src属性的图片地址

```html
<body>
  <!--
setInterval(函数,间隔时间) 每隔固定间隔时间(毫秒)执行一次函数 
document.querySelector(css选择器) 根据css选择器获取匹配到的一个标签
-->

  <div>
    <img id="myImg" src="" alt="" width="500px">
  </div>


  <script>
    //通过DOM获取img标签的js对象
    let img = document.getElementById("myImg");
    console.log(img);
    console.log(img.src);//获取img标签的src属性值



    //图片编号
    let num = 1;

    //定义一个修改图片的方法
    function change() {
      img.src = '../img/' + num + '1.jpg';
      if (num == 4) {
        num = 0;
      }else {
        num++;
      }
    }

    //每间隔3秒，触发此方法
    setInterval('change()', 3000);


    //每间隔1秒，向控制台输出一句话
    //''相当于script标签
    // setInterval('console.log("Hello");', 1000);

  </script>
```


三.JS事件
3.1 常用事件
点击事件
•onclick:单击事件
•ondblclick:双击事件

焦点事件
•onblur:失去焦点
•onfocus:元素获得焦点

加载事件
•onload:页面加载完后立即发送

鼠标事件
•onmousedown:鼠标按钮被按下
•onmouseup:鼠标按钮被松开
•onmousemove:鼠标被移动
•onmouseover:鼠标移到某元素之上
•onmouseout:鼠标从某元素一开

键盘事件
•onkeydown:某个键盘按键被按下
•onkeyup:某个键盘按键被松开
•onkeypress:某个键盘按键被按下并松开

改变事件
•onchange:域的内容被改变

表单事件
•onsubmit:提交按钮被点击

3.2 事件绑定
将事件与html标签进行绑定，实现交互功能

```html
<body>

  <input type="button" value="普通函数" onclick="show()"><br>
  <input type="button" value="匿名函数" id="myBtn">

  <script>
    //单击事件
    //普通函数 此方案有耦合性
    function show() {
      alert("普通函数触发事件");
    }


    //匿名函数
    //通过DOM技术获取按钮标签的js对象
    // var myBtn = document.getElementById("myBtn");
    // myBtn.onclick = function () {
    //     alert("匿名函数触发事件");
    // }

    document.getElementById("myBtn").onclick = function () {
      alert("匿名函数触发事件");
    };

  </script>
</body>
```


3.3 案例:页面交互
需求:给页面表单空间绑定对应事件

```html
<body>
  <!--
常用事件
1)onload:页面加载完后立即发送
2)onfocus:元素获得焦点
3)onblur:失去焦点
4)onchange:域的内容被改变
5)onclick:单击事件
-->
  Name: <input type="text" id="userName"><br/>
  Score:

  <select name="edu" id="edu">
    <option value="0">A</option>
    <option value="1">B</option>
    <option value="2">C</option>
  </select>

  <br/>
  <!--button相当于<input type="button" value="button">-->
  <button id="btn">Button</button>

  <script>


    // js代码的执行自上而下(顺序结构)
    //1.onload页面加载完成
    window.onload = function () {
      console.log("Page Load Done");//放在哪里都是最后执行
    }
    console.log("外部内容");

    //2.onfocus
    //this 当前对象
    document.getElementById('userName').onfocus = function () {
      // document.getElementById('userName').value = 'Focus';
      this.value = 'Focus';
    }

    //3.onblur
    document.getElementById('userName').onblur = function () {
      this.value = 'lose Focus';
    }

    //4.onchange
    document.getElementById("edu").onchange = function () {
      alert(this.value);
    }

    //5.onclick
    document.getElementById('btn').onclick = function () {
      alert('onclick Event');
    }

  </script>
</body>
```

四.JS常用内置对象
4.1 String对象

```html
<body>
  <!--
1.构造字符串对象可以使用单引号，双引号，反引号
2.字符串常用方法
substring()
toLowerCase()
toUpperCase()
split()
trim()
-->

  <script type="text/javascript">
    //1.构造字符串对象可以使用单引号，双引号，反引号
    //单引号
    let str1="String";
    console.log(str1);
    //双引号
    let str2="String";
    console.log(str2);
    //反引号
    let str3=`String`;
    console.log(str3);


    //反引号案例
    let num=100;
    let str4=`Need ${num} to do Something`;
    console.log(str4);

    //字符串常用方法
    // substring
    let str = '我爱我的祖国'; console.log(str.substring(4, 6));

  </script>
</body>
```

4.2 Array对象

```html
<body>
  <!--
数组:
1.创建数组
*let array=[ele1,ele2,ele3];
let array=new array(ele1,ele2,ele3);
特点:数组元素的类型任意

2.数组常用方法
concat() 连接两个或更多数组，并返回结果
push() 向数组末尾添加一个或多个元素，并返回一个新的长度
pop()删除并返回数组的最后一个元素
join()把数组所有元素放入一个字符串，元素通过指定的分隔符分隔。
与字符串.split()切割为数组方法相反
sort()对数组进行升序排序
reverse()对数组进行降序排序

-->

  <script>
    //1.创建数组
    let arr1 = ['a', 'b', 'c'];
    console.log(arr1);


    let arr2 = new Array('AAA', 5, new Date());
    console.log(arr2);
    //2.数组合并
    let concatArr = arr1.concat(arr2);
    console.log(concatArr);
    //3.添加元素,尾部添加
    concatArr.push("New");
    console.log(concatArr);
    //4.删除元素,尾部删除
    concatArr.pop('New');
    console.log(concatArr);
    //5.数组元素拼接为字符串
    console.log(concatArr.join('-'));
    //6.排序数组元素
    let arr3 = [2, 4, 5, 1, 3, 7];
    console.log(arr3.sort());
    console.log(arr3.reverse());
    //指定sort()排序规则
    console.log(arr3.sort(function (a, b) {
      return b - a;
    }));

  </script>
</body>
```

4.3 Date对象

```html
<body>
  <!--
日期
let date = new Date();
-->

  <script>
    let date = new Date();


    console.log(date);
    console.log(date.toLocaleString());//转换为本地日期格式的字符串
    console.log(date.getFullYear());//年
    console.log(date.getMonth() + 1);//月
    console.log(date.getDate());//日
    console.log(date.getDay());//星期
    console.log(date.getTime());//1970至今的毫秒值

  </script>
</body>
```

4.4 Math对象

```html
<body>
  <!--
数学运算
1)四舍五入 round()
2)向下取整 floor()
3)向上取整 ceil()
4)产生随机数 random() 返回[0,1)至今的随机数。左闭右开
-->

  <script>
    let a = 1234.567;
    //round
    console.log(Math.round(a));
    console.log(Math.floor(a));
    console.log(Math.ceil(a));
    console.log(Math.random());
    console.log(Math.floor(Math.random() * 100+1));
  </script>

</body>
```


4.5 全局函数
不需要通过任何对象，可以至今调用的就称为全局函数

```html
<body>
  <!--
全局函数
1)字符串转为数字
parseInt()解析一个字符串并返回一个整数
parseFloat()解析一个字符串并返回一个浮点数
特点:从一个字符开始转换，遇到非数值字符停止转换
NaN:not a number, NaN != NaN
isNaN() 判断一个字符串，如果不是数值返回true,否则返回false,即纯数值返回false

2)对字符串编码和解码
HTTP 不识别中文，需要转码
encodeURI()把字符串编码为uri
decodeURI()把uri解码为字符串

3)把字符串当作js表达式来执行
eval() 计算JavaScript字符串，识别为JS脚本片段


-->

  <script>
    //1.字符串转为数字
    let a = '123.932';
    console.log(parseInt(a));//123
    console.log(parseFloat(a));//123.932


    let b = '123.9a32';
    console.log(parseInt(b));//123
    console.log(parseFloat(b));//123.9

    let c = 'a123.9a32';
    console.log(parseInt(c));//NaN
    console.log(parseFloat(c));//NaN

    console.log(NaN == NaN);//false

    console.log(isNaN(a));//false
    console.log(isNaN(c));//true

    // 2.对字符串编码和解码
    let name = "一二三";
    var message = encodeURI(name);
    console.log(message);
    console.log(decodeURI(message));

    //3.把字符串当作js表达式来执行
    eval('alert(1)');

  </script>
</body>
```


总结:
js基础语法
运算符
算数运算符

数值可以与字符串进行数学运算，底层进行了转换
比较运算符

=== 恒等 先比较类型后比较内容
!== 恒不等 先比较类型后比较内容
流程控制语句
顺序

代码自上而下，逐行执行
分支

条件语句

和java一样

if…else if…else
switch…case..default
循环

和java一样的

while
do…while
for…i
和java不一样的

for…in

数组的索引index
for…of

数组的元素
js函数(方法)
普通函数
在js中，没有方法重载
匿名函数
案例:轮播图
setInterval(函数,间隔时间)
document.getElementById(id属性值)
js事件
作用
JS可以监听用户的行为,并调用函数来完成用户交互功能
常用事件
页面加载完毕事件

window.onload
获取焦点

onfocus
失去焦点

onblur
值改变时

onchange
单击时

onclick
事件绑定
普通函数

匿名函数

解耦合….
案例：页面交互
js常用内置对象
String 对象
构造

双引号

单引号

反引号

我爱我的祖国 ${变量占位符}
常用方法

截取

substring()
分割为数组

split()
转换大小写

toLowerCase()
toUpperCase()
去掉前后空格

trim()
Array 对象
构造

[ele1,ele2,ele3];
new Array(ele1,ele2,ele3);
特点：

数组的长度和类型任意，可以把它当做java的集合
常用方法

连接数组

concat()
拼接为字符串

join()
添加/移出元素

push()
pop()
排序

sort()
Date 对象
Math 对象
round 四舍五入
floor 向下取整
ceil 向上取整
random 返回[0,1)随机小数
全局函数
字符串转为数字

parseInt()

转整数
parseFloat()

转小数
isNaN()

非数字
url编码

encodURI()

编码
decodeURI()

解码
执行字符串

eval()

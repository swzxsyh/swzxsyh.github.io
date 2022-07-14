---
title: JavaScript 进阶笔记
date: 2020-04-09 01:05:20
tags:
---

一.BOM对象
1.1 BOM简介
浏览器对象模型(Browser Object Model)
作用:把浏览器抽象成一个对象模型,可以使用JS模拟一些浏览器功能
1.2 Window对象
三种弹框
警告框:提示信息
alert()
确认框:确认信息
confirm()
输入框:输入信息
prompt()

```javascript
<script>
  //警告框:提示信息
  alert("Hello")
//确认框:确认信息
let result = confirm("Sure to Delete?Y/N")
if (result == true) {
  console.log("Y");
} else {
  console.log("N");
}
//输入框:输入信息
let age = prompt("Please Input Your Age");
if (age != null) {
  console.log("Please Input Age",`${age}`)
}else {
  console.log("Canceled");
}
</script>
```

二种定时器
```html
<body>
  <!--
JS两个定时器
1)一次性定时器
创建:let 定时器对象 = setTimeout(`函数()`,毫秒)
关闭:clearTimeout(定时器对象)
2)循环型定时器
创建:    let 定时器对象 = setInterval(函数,毫秒)
关闭:clearInterval()
-->
  <button id="btn1">Cancel Print Time</button>
  <button id="btn2">Cancel Print Number</button>

  <script>


    //1.定时1s在控制台打印当前时间
    function fun1() {
      console.log(new Date().toLocaleString());
    }

    let timeout = setTimeout(`fun1()`, 1000);

    //2.点击按钮取消打印时间
    document.getElementById("btn1").onclick = function () {
      clearTimeout(timeout);
    }

    //3.每隔2秒在控制台打印递增自然数
    let num = 1;

    function fun2() {
      console.log(num++);
    }

    let interval = setInterval(fun2, 2000);

    //4.点击按钮取消打印自然数
    document.getElementById('btn2').onclick = function () {
      clearInterval(interval);
    }

  </script>
</body>
```

1.3 Location对象

```html
<body>
  <!--
location地址
1)获取当前窗口地址
location.href
2)刷新当前页面
location.reload
3)跳转页面
location.href='new location'
-->

  <button onclick="addr()">获取当前浏览器地址</button>
  <button onclick="refresh()">刷新当前页面</button>
  <button onclick="jump()">跳转页面(重点)</button>

  <script>
    function addr() {
      console.log(location.href);
    }
    function refresh() {
      console.log(location.reload());
    }
    function jump() {
      console.log(location.href = 'https://www.baidu.com/');;
    }
  </script>

</body>
```

二.DOM对象
2.1 DOM简介
DOM(Document Object Model) 页面文档对象模型
JS把页面抽象成为一个对象,允许我们使用js来操作页面

2.2 DOM获取元素
第一种:es6之前的获取方式
1)获取一个:
document.getElementById(id属性值)
2)获取多个:
document.getElementByTagName(标签名属性值) 根据标签名获取，返回数组对象
document.getElementByClassName(class属性值) 根据class属性获取，返回数组对象
document.getElementByName(name属性值) 根据name属性获取，返回数组对象
第二种:es6可根据CSS选择器获取
1)获取一个:
document.querySelector(id选择器)
2)获取多个:
document.querySelectorAll(css选择器)
标签
class
属性
后代
并集
父子
…

```js
<script>
  //1.获取id="name"对象
  console.log(document.getElementById('name'));
console.log(document.querySelector('name'));
//2.获取class="radio"的标签数组
console.log(document.getElementsByClassName('radio'));
console.log(document.querySelectorAll('radio'));
//3.获取所有option标签对象数组
console.log(document.getElementsByTagName('option'));
console.log(document.querySelectorAll('option'));

//4.获取name="hobby"的input标签对象数组
console.log(document.getElementsByName('hobby'));
console.log(document.querySelectorAll('input[name="hobby"]'));//CSS的属性选择器

//5.获取文件上传选择框
console.log(document.querySelectorAll('form input[type="file"]'));
</script>

```

2.3 DOM操作内容
获取或修改元素(标签)的纯文本内容
语法:
element.innerText
获取或者修改元素的html内容
element.innerHTML;
获取或者修改包含自身的html内容
element.outerHTML;
总结:

innerText 获取的是纯文本 innerHTML获取的是所有html内容
innerText 设置到页面中的是纯文本 innerHTML设置到页面中的html会展示出外观效果
innerHTML不包含自身 outerHTML包含自身的html内容

```html


<head>
  <meta charset="UTF-8">
  <title>Title</title>
  <style>
    #myDiv {
      border: 1px solid red;
    }
  </style>
</head>

<body>

  <div id="myDiv">AAA</div>
  <script>
    let myDIV = document.getElementById('myDiv');
    //1.innetText操作div内容
    //1.1获取纯文本
    console.log(myDIV.innerText);
    //1.2 获取纯文本,无法更改标签等属性
    myDIV.innerText = "BBBBB";//覆盖
    myDIV.innerText += "BBBBB";//追加


    //2.innerHTML操作div内容
    //2.1 获取超文本内容
    console.log(myDIV.innerHTML);
    //2.2 设置超文本,可以更改标签等属性
    myDIV.innerHTML = '<h1>CCCCCC</h1>'//覆盖
    myDIV.innerHTML += '<h1>CCCCCC</h1>'//追加

    //3.outerHTML操作div
    myDIV.outerHTML='<p>DDDDDDDD</p>'//不仅可以修改纯文本，还能修改标签

  </script>
</body>
```

2.4 DOM操作属性
获取文本框的值,单选框或复选框的选中状态
语法:
element.properties 获取或者修改元素对象的原生属性
给元素设置自定义属性
语法:
element.setAttribute(属性名,属性值) 给元素设置一个属性值,可以设置原生和自定义
获取元素的自定义属性值
语法:
element.getAttribute(属性名) 获取元素的一个属性值,可以获取原生和自定义
移除元素的自定义属性
语法:
element.removeAttribute(属性名)

```html
<body>

  <form action="#" method="post">
    Name: <input type="text" name="username" id="username" value="AAAAA"/><br/>


    Hobby:
    <input type="checkbox" name="hobby" value="smoke">X
    <input type="checkbox" name="hobby" value="drink">Y
    <input type="checkbox" name="hobby" value="perm">Z<br/>

    <input type="reset" value="清空按钮">
    <input type="submit" value="提交按钮"><br/>

  </form>

  <script>
    //1.获取文本框预定义的属性值
    let username = document.getElementById('username');
    console.log(username);
    console.log(username.type);
    console.log(username.name);
    console.log(username.value);
    //2.给文本框设置自定义属性
    username.setAttribute('customize', 'customize properties');
    //3.获取文本框自定义属性
    console.log(username.getAttribute('customize'));
    //4.移除文本框自定义属性
    username.removeAttribute('customize');
    username.removeAttribute('value');
  </script>

</body>
```


2.5 DOM操作样式
设置一个css样式
语法:
element.style.样式名=’样式值’ 获取或者修改一个css样式
特点:
驼峰格式样式属性名
css格式:font-size
js格式:fontSize

批量设置css样式
语法:
element.style.cssText 获取后者修改 标签的style属性的文本值
特点:有耦合性，无提示较麻烦

通过class设置样式
语法:
element.className=’class选择器名’ 获取或者修改标签的class属性的文本值

切换class样式
语法:
element.classList es6特别提供的操作元素class的接口
常用方法有四个:
add() 添加一个class样式
remove() 移除一个class样式
contains() 判断是否包含某一个样式
toggle() 切换一个class样式 有则删除,无则添加

```html


<head>
  <meta charset="UTF-8">
  <title>Title</title>
  <style>
    #p1 {
      background-color: red;
    }


    .mp {
      color: green;
      font-size: 30px;
      font-family: "Cascadia Code";
    }

    .mpp {
      background-color: lightgray;
    }

  </style>

</head>
<body>

  <p id="p1">Set One CSS Style</p>
  <p id="p2">Set CSS Style</p>
  <p id="p3">Set CSS Style By Class</p>

  <script>
    let p1 = document.getElementById('p1');
    let p2 = document.getElementById('p2');
    let p3 = document.getElementById('p3');


    //1.设置一个css样式
    p1.style.backgroundColor = 'black';
    p1.style.color = 'white';

    //2.批量设置css样式
    p2.style.cssText = 'border:1px solid red;font-size:20px';

    //3.通过class设置样式
    p3.className = 'mp mpp';//注意不要添加'.'符号,可以添加多个组

  </script>
</body>
```

2.6 DOM操作元素
创建一个标签对象
语法:
innerHTML 获取或者设置标签的html内容
父标签添加子标签
语法:
document.createElement(标签名称) 创建一个标签对象
parentNode.appendChild(newNode) 给父标签添加一个子标签
移除元素
outerHTML

```html
<body>

  <ul id="name">
    <li>A</li>
    <li>B</li>
  </ul>
  <script>
    //添加一个心列表
    //方式一
    document.getElementById("name").innerHTML += '<li>C</li>';
    //方式二
    //1.1 创建li标签
    let li = document.createElement('li');
    li.innerText = 'All';
    console.log(li);
    //1.2 父标签添加子标签
    document.getElementById('name').appendChild(li);
  </script>

</body>
```


三.正则表达式
作用:根据定义好的规则，过滤文本内容

在js中使用正则表达式
创建方式
1)let reg1 = new RegExp(‘正则表达式字符串’);
2)let reg1 = /正则表达式/;
验证方法
1)正则对象.test(字符串)
符号正则规则就返回true，否则false
2)字符串对象.match(正则对象)
返回字符串中符号正则规则的内容

正则表达式修饰符
i忽略大小写 g全局匹配 m 多行匹配

```html
<body>

  <script>
    //1.创建正则对象
    let reg1 = new RegExp('\\d+');
    console.log(reg1.test('abc'));
    console.log(reg1.test('123'));


    let reg2 = /\d+/;
    console.log(reg2.test('abc'));
    console.log(reg2.test('123'));

    //验证方法
    console.log("a1".match(reg2));//表示获取字符串符号正则规则的部分

    //正则表达式修饰符
    //i忽略大小写  g全局匹配 m 多行匹配
    let regi = /[]amn]/i;//不区分大小写匹配amn ignore忽略大小写
    let resi = 'ABC'.match(regi);//从ABC中匹配regi模式字符串
    console.log(resi);
    let regg = /\d/g;//全局查找数组 global 全局
    let resg = "1 plus 2 equels 3".match(regg);
    console.log(resg);
    let regm = /^\d/m;//多行匹配开头的数字(^限定开始 $限定结束) ，multipart
    let resm = "abc1 plus 2 equals 3\n6abcmnk".match(regm);
    console.log(resm);

  </script>
</body>
```

四.综合案例
4.1 表单校验

```js
//1.两次密码输入一致
//2.获取密码框和确认密码框的js对象
let
pwd1 = document.getElementById('pwd1');
let pwd2 = document.getElementById('pwd2');

//1.2 校验密码是否一致的方法
function checkPwd() {
  let boo = pwd1.value == pwd2.value;
  if (boo == true) {
    document.getElementById('pwdwarn').style.display = 'none';
  } else {
    document.getElementById('pwdwarn').style.display = 'inline';
  }
  return boo;
}

//1.3 给确认密码框绑定失去焦点时间
pwd2.onblur = checkPwd;//不能加括号()

//2.邮箱格式正确
//2.1 定义邮箱正则表达式

//2.2 获取邮箱的js对象
let email = document.getElementById('email');
let emailReg = /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/;

//2.3 定义校验函数(方法)
function checkEmail() {
  let boo = emailReg.test(email.value);
  if (boo == true) {
    document.getElementById('emailwarn').style.display = 'none';
  } else {
    document.getElementById('emailwarn').style.display = 'inline';
  }
  return boo;
}

//2.4 给邮箱绑定失去焦点事件
email.onblur = checkEmail;

//3.手机号格式正确

let phone = document.getElementById('phone');
let phoneReg = /^((0\d{2,3}-\d{7,8})|(1[3584]\d{9}))$/;

function checkPhone() {
  let boo = phoneReg.test(phone.value);
  if (boo == true) {
    document.getElementById('phonewarn').style.display = 'none';
  } else {
    document.getElementById('phonewarn').style.display = 'inline';
  }
  return boo;
}

phone.onblur = checkPhone;

//表单提交时进行校验 一定触发onsubmit()事件
document.getElementById('myForm').onsubmit = function () {
  if (checkPwd() && checkEmail() && checkPhone()) {
    alert('Successful')
    return true;
  } else {
    alert('Something Wrong')
  }
}
```

点我展开html和css
4.2 商品全选

```html
<body>
  <button id="btn1">1.全选</button>
  <button id="btn2">2.反选</button>
  <button id="btn3">3.全部取消</button>
  <br>
  <input type="checkbox">Computer
  <input type="checkbox">Phone
  <input type="checkbox">Car
  <input type="checkbox">House
  <input type="checkbox" checked="true">NoteBook

  <script>
    let boxs = document.querySelectorAll('input[type="checkbox"]');


    document.getElementById('btn1').onclick = function () {
      for (let box of boxs) {
        box.checked=true;
      }
    }
    document.getElementById('btn2').onclick = function () {
      for (let box of boxs) {
        box.checked=!box.checked;
      }
    }

    document.getElementById('btn3').onclick = function () {
      for (let box of boxs) {
        box.checked=false;
      }
    }

  </script>
</body>
```

4.3 省市联动

```js
var data = new Array();
data['A'] = ['A1', 'A2', 'A3'];
data['B'] = ['B1', 'B2', 'B3'];
data['C'] = ['C1', 'C2', 'C3'];

let provinceID = document.getElementById("provinceId");
let cityID = document.getElementById("cityId");

//1.页面加载成功后，初始化省份数据
window.onload = function () {
  for (let index in data) {
    console.log(index);
    provinceId.innerHTML +=`<option value="${index}">${index}</option>`;
  }
}
//2.给省份下拉框绑定onchange事件
provinceId.onchange = function () {
  console.log(this.value);//当前用户选中的value值,它就是二维数组的索引
  console.log(data[this.value]);
  //3.城市列表
  cityId.innerHTML = '<option value="">----请-选-择-市----</option>';
  console.log(this.value);
  console.log(data[this.value]);
  let citys = data[this.value];
  for (let city of citys) {
    cityId.innerHTML += `<option value="${city}">${city}</option>`;
  }
}
```

4.4 隔行换色

```js
let oldColor;
//获取所有数组对象
let trs = document.querySelectorAll('table tr');//注意:这里使用的是后代选择器,这里是js的一个小坑

for (let i = 0; i < trs.length; i++) {
  if (i % 2 == 0) {//偶数索引,奇数行
    trs[i].style.backgroundColor = 'lightgray';
  } else {//奇数索引，偶数行
    trs[i].style.backgroundColor = 'skyblue';
  }
  trs[i].onmouseover = function () {//鼠标移入某一行
    //获取当前行的颜色
    oldColor=trs[i].style.backgroundColor;
    trs[i].style.backgroundColor = 'brown';
  }
  trs[i].onmouseout = function () {//鼠标移出某一行
    trs[i].style.backgroundColor=oldColor;
  }
}
let tds = document.querySelectorAll('table td');
for (let i = 0; i < tds.length; i++) {
  tds[i].onmouseover=function(){
    tds[i].style.backgroundColor='Green';
  }
  tds[i].onmouseout = function () {//鼠标移出某一行
    tds[i].style.backgroundColor=oldColor;
  }
}
```

4.5 拓展:为什么不用var
ES6之前作用域为全局，容易导致变量有值被新值替代，局部变量使用let可以自动销毁，推荐let

```js


// for循环举例：var声明变量全局作用域、let声明变量是局部作用域
for (var i = 0; i < 5; i++) {
  document.write('<h3>我是var修饰遍历的内容</h3>')
}
console.log(i);

for (let j = 0; j < 5; j++) {
  document.write('<h3>我是let修饰遍历的内容</h3>')
}
// console.log(j);


{
  var a = 10;
  let b = 5;
}
console.log(a); // 可以取到
console.log(b); // 不能取到
```



总结:
BOM对象
简介
浏览器对象模型
Window对象
三种弹框

alert()
confim()
prompt()
二种定时器

setTimeout(函数,毫秒)

clearTimeout(定时器)
setInterval(函数,毫秒)

clearInterval(定时器)
Location对象
reload()

href

跳转页面
DOM对象
简介
文档对象模型
获取元素
ES5

getElementById(id属性值)
ES6

querySelector(CSS选择器)
querySelectorAll(CSS选择器)
操作内容
innerText
innerHTML
操作属性
js对象.属性名

原生属性
操作样式
js对象.style.样式名(驼峰格式)
js对象.style.cssText
js对象.className
操作元素
添加元素

js对象.innerHTML +=追加内容

document.createjs对象(标签)

parentNode.appendChild(newNode)
正则表达式
创建
let rege = new RegExp(“正则表达式”);
let regex = /正则表达式/;
验证方法
正则对象.test(字符串)
综合案例
表单校验
发挥大家的想象力
商品全选
省市联动
隔行换色
---
title: XML,DOM4j
date: 2020-03-30 00:55:35
tags:
---


一.XML概述
1.1 XML初识

XML介绍以及版本
XML是可扩展标记语言(Extensible Markup Language)
语言：XML也是一种语言
标记：是指标签(Tag)/元素(Element),<标签名>/<标签名>
可扩展：标签可以随意定义

XML版本：
XML 1.0(使用)
XML 1.1(不使用)

XML与HTML的主要差异
a.XML主要是用于传输和保存数据(目前更倾向于保存,传输用Json)
b.HTML是用来显示数据

XML入门小案例
•需求
编写XML文档,保存人员信息,Person人员,SID编号,AGE年龄,Name姓名,Gender性别
•编写

1
2
3
4
5
6
<?xml version="1.0" encoding="UTF-8" ?>
<Person sid = "001">
    <AGE>20</AGE>>
    <Name>JSW</Name>
    <Gender>Male</Gender>
</Person>
•运行
使用浏览器打开XML即可

XML的作用
a.XML可以存储数据(也可以传输数据,但目前已用Json传输)
b.XML也可以作为配置文件(给框架使用的)

1.2 XML的语法学习

XML的组成元素
•文档声明
什么是文档声明：表面这就是一个XML文件
文档声明必须写在XML文件的0行0列(左上角)
固定格式:
1
<?xml version="1.0" encoding="UTF-8" ?>
•元素element
格式：
1
2
3
4
5
<Element>
    <other>Tag Body<other>
</Element>>
或
<Element/>自闭合标签,不写任何内容使用此标签
命名要求:
a.区分大小写
b.不能使用空格、冒号等特殊字符
c.不建议 以XML,xml,Xml开头

注意：一个格式良好的XML文档,有且仅有一个根标签

•属性attribute
a.属性是元素的一部分,必须写在元素的开始标签
b.格式：属性名 = “属性值”,其中属性值必须使用单引号或双引号
c.一个元素可以有0-N个属性,但是不能有同名属性,也一样不能使用特殊字符

•注释

1
<!-- -->
•转义字符

字符	预定义的转义字符	说明
<	&lt;	小于
>	&gt;	大于
“	&quot;	双引号
‘	&apos;	单引号
&	&amp;	和号
•字符区
当出现大量需要转义的字符时,不建议逐一转义,会增加复杂度且降低可读性
使用CDATA区中写所有字符,会自动转义

1
2
3
<![CDATA[
可以使用任何内容
]]>
二.XML约束
概述：就是编写XML文件的标签的规则

2.1 DTD约束

什么是DTD约束
文档类型定义约束,规定我们在编写XML时具体的标签,子标签,属性等

DTD约束体验
a.bookshelf.dtd 这就是DTD约束文件
b.创建一个book.xml
c.在XML中引入dtd约束
d.根据IDE提示,编写出符合DTD约束的XML文件

1
2
3
4
5
<!ELEMENT 书架 (书+)>
        <!ELEMENT 书 (书名,作者,售价)><!--约束元素书的子元素必须为书名、作者、售价-->
        <!ELEMENT 书名 (#PCDATA)>
        <!ELEMENT 作者 (#PCDATA)>
        <!ELEMENT 售价 (#PCDATA)>
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
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE 书架 SYSTEM "bookshelf.dtd"><!--指定使用bookshelf.dtd文件约束当前xml文档--> <书架>
    <书>
        <书名>JavaWeb开发教程</书名>
        <作者>张孝祥</作者>
        <售价>100.00元</售价>
    </书>
    <书>
    <书名>三国演义</书名>
    <作者>罗贯中</作者>
    <售价>100.00元</售价>
<!--    <测试>hello</测试>    不符合约束,书的子元素必须为书名、作者、售价-->
    </书>
</书架>
注意:开发中基本不会写DTD文件,而是由框架提供,根据DTD编写符合要求的XML文件

DTD约束语法
•DTD的引入
a.内部DTD(把DTD直接写在XML中,这种方式只能对当前XML有效)
1
2
3
4
<?xml version="1.0" encoding="UTF-8"?> 
<!DOCTYPE 根元素 [...//具体语法]><!--内部DTD--> 
<根元素>
</根元素>
b.外部DTD – 本地DTD
1
2
3
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE 根元素 SYSTEM "bookshelf.dtd"><!--外部本地DTD--> <根元素>
</根元素>
c.外部DTD – 公共DTD
1
2
3
4
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE web-app PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN" "http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
</web-app>
•DTD中的数量词

数量词符号	含义
*	表示元素可以出现0到多个
+	表示元素可以出现至少1个
？	表示元素可以是0或1个
,	表示元素需要按照顺序显示
|	表示元素需要选择其中的某一个
•其他语法

1
2
3
4
5
<!ATTLIST 标签名称
属性名称1 属性类型1 属性说明1
属性名称2 属性类型2 属性说明2
...
>
属性类型：

属性类型：	含义
CDATA	代表属性是文本字符串, eg:
ID	代码该属性值唯一,不能以数字开头, eg:
ENUMERATED	代表属性值在指定范围内进行枚举 Eg:
属性说明：

属性说明	含义
#REQUIRED	代表属性是必须有的
#IMPLIED	代表属性可有可无
#FIXED	代表属性为固定值,实现方式:book_info CDATA #FIXED “固定值”
1
2
3
4
5
6
7

<!ATTLIST 书                        <!--设置"书"元素的的属性列表--> 
id ID #REQUIRED                     <!--"id"属性值为必须有--> 
编号 CDATA #IMPLIED                  <!--"编号"属性可有可无-->
出版社 (清华|北大|传智播客) "传智播客"   <!--"出版社"属性值是枚举值,默认为“传智播客”--> 
type CDATA #FIXED "IT"              <!--"type"属性为文本字符串并且固定值为"IT"-->
>
2.2 Schema约束

什么是Schema约束
也是用于约束XML文件的,是DTD的代替者,添加了 数据类型 的约束
本身也是XML,后缀名是.xsd

Schema的约束体验
a.bookshelf.xsd 就是Schema的约束文档
b.创建自己的XML文件,把Schema中需要复制的内容复制进去,其实Schema中复制过来是根标签的开始标签,需要补充完整标签

1
2
3
4
<!--
<书架 xmlns="http://www.Oracle.cn"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.Oracle.cn bookshelf.xsd"
> -->
bookshelf.xsd

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
<?xml version="1.0" encoding="UTF-8" ?> <!--
<书架 xmlns="http://www.Oracle.cn"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.Oracle.cn bookshelf.xsd"
> -->
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
           targetNamespace="http://www.Oracle.cn"
           elementFormDefault="qualified">
    <xs:element name='书架' >
    <xs:complexType>
        <xs:sequence maxOccurs='unbounded' >
            <xs:element name='书' > <xs:complexType>
                <xs:sequence>
                    <xs:element name='书名' type='xs:string' />
                    <xs:element name='作者' type='xs:string' />
                    <xs:element name='售价' type='xs:double' />
                </xs:sequence>
            </xs:complexType>
            </xs:element>
        </xs:sequence>
    </xs:complexType>
    </xs:element>
</xs:schema>
c.根据提示完成自己的XML

1
2
3
4
5
6
7
8
9
<?xml version="1.0" encoding="UTF-8"?>
<书架
        xmlns="http://www.oracle.cn" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.oracle.cn bookshelf.xsd" ><!--指定schema文档约束当前XML文档-->
    <书>
        <书名>JavaScript网页开发</书名>
        <作者>张孝祥</作者>
        <售价>1</售价>
    </书>
</书架>
Scheme语法和命名空间
作用就是处理元素和属性的名称冲突问题,与Java中的包类似,不同命名空间可能有相同的标签

1
2
3
4
5
xmlns="http://www.oracle.cn"
<!-- 缺省的名称空间.使用此约束中的元素的时候只需要写元素名即可 例如:<书></书> -->

xmlns:aa="http://java.sun.com"
<!-- aa就是此约束的别名,使用此约束中的元素的时候就需要加上别名 例如:<aa:书></aa:书> -->
引用了两个命名空间,
如果直接写<书> 表示http://www.oracle.cn 命名空间下的书
如果写aa:书 表示http://java.sun.com 命名空间下的书

2.3 XML约束的学习要求:
重点是根据框架提供的DTD/Scheme约束,编写出符合要求的XML文档

三.XML解析
3.1 什么是XML解析
通过代码将XML文件中保存的数据读取出来

3.2 解析方式和解析器和解析开发包
a.解析方式(思想)
•DOM解析：把整个XML加载到内存,进行解析,解析后产生一个Document对象
优点：元素之前结构得以保留,文档结构完整,可以通过Document对象对标签进行增删改查操作
缺点：如果XML文件过大,可能导致内存溢出

•SAX解析：扫描XML文档,扫描一行解析一行,解析完毕后释放该行资源
优点：速度快,可以处理大文件
缺点：只能读,逐行读取后释放资源,解析操作繁琐

•PULL解析：是安卓系统内置的XML解析方式,类似SAX

b.解析器：根据解析方式,写出对应的解析代码(代码需要考虑解析过程中的每个标签,非常繁琐)

c.解析开发包：对解析器繁琐API的封装,提供简单方便的API

常见的解析开发包：
•JAXP:sun公司提供支持DOM和SAX开发包
•Dom4j:比较简单的的解析开发包(常用)
•JDom:与Dom4j类似
•Jsoup:功能强大DOM方式的XML解析开发包,尤其对HTML解析更加方便

3.3 Dom4j的基本使用

DOM的解析原理
将整个XML稳定加载到内存，进行解析，解析之后生成一个Document对象(道理的DOM树)

DOM树的结构模型

![image](./XML-DOM4j/DOM%E6%A0%91%E7%9A%84%E7%BB%93%E6%9E%84%E6%A8%A1%E5%9E%8B.svg)

DOM4j的jar包和常用API
在模块下创建一个lib文件夹(必须叫lib),然后把dom4j-1.6.1.jar包放入lib中(Day22/lib/dom4j-1.6.1.jar)
将lib下的jar包添加到模块中：
a.选中右键 –> add as library
b.点击File –> Project Structure –> 先在Library添加jar包 –> 然后在Moudle加入即可
SAXReader对象

核心类	作用
new SAXReader()	构造器
Document read(File file)	加载执行xml文档
Document对象

方法	作用
Element getRootElement()	获得根元素
Element对象

方法	作用
List elements([String ele] )	获得指定名称的所有子元素。可以不指定名称
Element element([String ele])	获得指定名称第一个子元素。可以不指定名称
String getName()	获得当前元素的元素名
String attributeValue(String attrName)	获得指定属性名的属性值
String elementText(Sting ele)	获得指定名称子元素的文本值
String getText()	获得当前元素的文本内容
DOM4j的代码演示

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
public class DOM4JDemo {
    public static void main(String[] args) throws DocumentException {
        //1.创建核心对象
        SAXReader reader = new SAXReader();
        //2.读取xml文件
        Document document = reader.read(new File("books.xml"));
        //3.获取根标签
        Element rootElement = document.getRootElement();
        System.out.println("根标签是:"+rootElement.getName());
        //4.获取book标签
        List<Element> bookElements = rootElement.elements();
        //5.遍历集合
        for (Element bookElement : bookElements) {
            //6.获取标签名
            String bookElementName = bookElement.getName();
            System.out.println("子标签:"+bookElementName);
            //7.获取id属性值
            String idValue = bookElement.attributeValue("id");
            System.out.println("属性id:"+idValue);
            //8.继续获取子标签
            List<Element> elements = bookElement.elements();
            //9.遍历
            for (Element element : elements) {
                //10.获取标签名
                System.out.println(element.getName());
                //11.获取文本
                System.out.println(element.getText());
            }
        }
    }
}
3.4 Dom4j结合XPath解析XML

什么是XPath
XML的路径表达式，可以快速从N层标签中选出需要的标签

Xpath使用步骤
在模块下创建一个lib文件夹(必须叫lib),然后把jaxen-1.1.2.jar包放入lib中(Day22/lib/jaxen-1.1.2.jar)
将lib下的jar包添加到模块中：
a.选中右键 –> add as library
b.点击File –> Project Structure –> 先在Library添加jar包 –> 然后在Moudle加入即可

和XPath相关的API介绍：
List

方法	作用
List selectNodes(“表达式”)	获取符合表达式的元素集合
Element selectSingleNode(“表达式”)	获取符合表达式的唯一元素
XPath语法
获取XML文档节点元素一共有如下4种XPath语法方式:
绝对路径表达式方式 例如: /元素/子元素/子子元素…
相对路径表达式方式 例如: 子元素/子子元素.. 或者 ./子元素/子子元素..
全文搜索路径表达式方式 例如: //子元素//子子元素
谓语(条件筛选)方式 例如: //元素[@attr1=value]
演示
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
public class XPathDemo {
    public static void main(String[] args) throws DocumentException {
        //1.创建核心对象
        SAXReader reader = new SAXReader();
        //2.读取xml文件
        Document document = reader.read(new File("books.xml"));
        //3.使用Xpath
        //全文搜索路径表达式
        List<Element> list = document.selectNodes("//sale");
        for (Element element : list) {
            System.out.println(element.getText());
        }
        //谓语表达式
        Element ele = (Element) document.selectSingleNode("//book[@id='0001']/sale");
        System.out.println(ele.getText());
    }
}

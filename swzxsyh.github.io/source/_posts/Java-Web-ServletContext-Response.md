---
title: Java Web - ServletContext & Response
date: 2020-04-16 01:19:47
tags:
---

一.ServletContext
1.1 概述
ServletContext是一个容器(域对象)可以存储键值对数据(String key,Object value)，保存在ServletContext中的 数据不仅可以提供给所有的servlet使用，而且可以在整个项目范围内使用。

它的主要作用有3个:
作为域对象
可以获取当前应用下任何路径下的任何资源
获取初始化参数
获取文件MIME类型

1.2 域对象
说明	API
往servletcontext容器中存入数据，name为数据名称，object为数据的值	void setAttribute(String name,Object object)
从ServletContext中获取数据，根据指定的数据名称	Object getAttribute(String name)
从ServletContext中移除数据，根据指定的数据名称	void removeAttribute(String name)
生命周期
何时创建:项目加载时创建
何时销毁:项目卸载时销毁
作用范围:整个项目(多个Servlet都可以使用它)
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
@WebServlet("/OneServlet")
public class OneServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //向ServletContext域存储数据
        ServletContext sc1 = req.getServletContext();
        ServletContext sc2 = getServletContext();
        sc1.setAttribute("user","jack");
        resp.getWriter().write("Set Message");
    }
}
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
@WebServlet("/TwoServlet")
public class TwoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //从ServletContext域存储数据
        String user = (String) req.getServletContext().getAttribute("user");
        resp.getWriter().write("Get Message:"+user);
    }
}
1.3 获取资源在服务器的真实地址
可以实现Web项目的移植性，动态获取文件真实路径
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
@WebServlet("/RealPath")
public class RealPath extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //获取web.xml文件真实路径
        String realPath = req.getServletContext().getRealPath("/WEB-INF/web.xml");
        resp.getWriter().write(realPath);
    }
}
1.4 获取全局的配置函数
读取web.xml配置文件中<context-param>标签,实现参数和代码的解耦(多个Servlet可以获取)
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
@WebServlet("/ContextPath")
public class ContextPath extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //获取全局参数
        String value = req.getServletContext().getInitParameter("encode");
        System.out.println(value);
        resp.getWriter().write(value);
    }
}
1
2
3
4
5
<!--   全局配置参数：所有Servlet都可以读取    -->
<context-param>
    <param-name>encode</param-name>
    <param-value>UTF-8</param-value>
</context-param>
1.5 获取文件MIME类型
互联网通信中的一种数据类型
格式:大类型/小类型
例如:text/html image/jpeg

1
<a href="/Day35_war_exploded/MIMEServlet?filename=a.jpeg">Get MIME</a>
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
@WebServlet("/MIMEServlet")
public class MIMEServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //获取请求参数
        String filename = req.getParameter("filename");
        //获取指定文件的mime类型
        String mimeType = req.getServletContext().getMimeType(filename);
        resp.getWriter().write(filename+"="+mimeType);
    }
}
1.6 案例:统计网站的访问次数
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
@WebServlet(value = "/CountServlet",loadOnStartup = 4)//服务器启动时，创建此servlet对象
public class CountServlet extends HttpServlet {
    @Override
    public void init() throws ServletException {
        getServletContext().setAttribute("count",0);
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //设置response响应编码
        resp.setContentType("text/html;charset=utf-8");
        resp.getWriter().write("<h1>Welcome</h1>");

        //用户每次访问,从域中取出，++再存入
        Integer count = (Integer) req.getServletContext().getAttribute("count");
        count++;
        getServletContext().setAttribute("count", count);

        resp.getWriter().write("<div>You are the "+count+" visitor</div>");
    }
}
二.Response
2.1 概述
response对象表示web服务器给浏览器返回的响应信息

作用:开发人员可以使用response对象方法,设置要返回给浏览器的响应信息

Response体系结构

ServletResponse
⬆
HttpServletResponse
⬆
org.apache.catalina.connector.ResponseFacade 实现类(由Tomcat提供)
2.2 设置Http响应消息
2.2.1 响应行
格式
协议/版本号 状态码
例如
HTTP/1.1 200
API
说明	API
设置状态码	void setStatus()
2.2.2 响应头
格式
响应头名称:响应头的值
例如
Location:http://www.oracle.com
API
说明	API
设置指定头名称和对应的值	void setHeader(String name,String vale);
2.2.3 响应体
API(输出流对象)
说明	API
字符输出流	PrintWriter getWriter()
字节输出流	ServletOutputStream getOutputStream()
注意:在同一个Servlet中，不能同时存在两种流，互斥

2.3 响应重定向
2.3.1 重定向特点
地址栏会发生改变
重定向是二次请求
重定向是客户端(浏览器)行为,可以跳转到服务器外部资源
不能使用request域共享数据
2.3.2 方式一
说明	API
设置状态码	response.setStatus(302)
设置响应头Location	response.setHeader(“Location”,”重定向网络地址”);
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
@WebServlet("/AServlet")
public class AServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("AServlet Run");
       resp.setStatus(302);
       resp.setHeader("Location","/Day35_war_exploded/BServlet");
    }
}
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
@WebServlet("/BServlet")
public class BServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("Bservlet Run");
    }
}
2.3.3 方式二
说明	API
response专门处理重定向的方法	response.sendRedirect(“重定向网络地址”)
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
@WebServlet("/AServlet")
public class AServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("AServlet Run");
        resp.sendRedirect("http://www.baidu.com");
    }
}
2.3.4 转发与重定向区别
哪个对象
API
转发(request对象的方法)	request.getRequestDispatcher(“/bServlet”).forward(request,response);
重定向(response对象的方法)	response.sendRedirect(“/Day35_war_exploded/bServlet”);
几次请求
转发	重定向
地址栏	没有改变	发生了改变
浏览器	发了一次请求	发了两次请求
服务器	只有一对请求和响应对象	有两对请求和响应对象
发生的位置	服务器	浏览器
小结
写法	说明
转发	(“/servlet资源路径”) 服务器内部行为
重定向	(“/虚拟路径(项目名)/servlet资源路径”) 浏览器外部行为
使用场景

使用场景	说明
如果需要传递数据(request域)	使用转发
如果不需要传递数据(request域)	使用重定向
2.4 响应定时刷新
说明	API
通过response设置响应头Refresh	response.setHeader(“Refresh”,”间隔时间(秒);跳转页面”)
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
@WebServlet("/RefreshServlet")
public class RefreshServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setHeader("Refresh","3;http://www.baidu.com");
        resp.setContentType("text/html;charset=utf-8");
        resp.getWriter().write("Success,Redirect After 3 seconds");
    }
}
2.5 响应中文
步骤:

说明	API
统一服务器编码:指定服务器响应编码方式	resp.setContentType(“text/html;charset=utf-8”);
通过response获取字符输出流	PrintWriter pw = response.getWriter();
通过字符输出流输出文本	pw.write()
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
@WebServlet("/EncodeServlet")
public class EncodeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //可以解决客户端中文乱码，但是编码不统一
//        resp.setCharacterEncoding("GBK");
        resp.setContentType("text/html;charset=utf-8");
//        PrintWriter pw = resp.getWriter();
//        pw.write("中文");

        //链式编程
        resp.getWriter().write("中文");
    }
}
综合案例
3.1 点击切换验证码
在页面展示登陆验证码，点击可以更换新验证码
作用:防止表单的恶意提交
本质:图片
1
2
3
4
5
6
7
8
<img src="/Day35_war_exploded/CheckCodeServlet" alt="" id="image1">
<script>
    document.getElementById("image1").onclick = function () {
        //reset src path
        // new Date().getTime()为了欺骗浏览器使用不同src，强制刷新
        this.src = '/Day35_war_exploded/CheckCodeServlet?' + new Date().getTime();
    }
</script>
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
49
50
51
52
53
54
55
56
57
58
59
60
@WebServlet("/CheckCodeServlet")
public class CheckCodeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//  创建画布
        int width = 120;
        int height = 40;
        BufferedImage bufferedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        //  获得画笔
        Graphics g = bufferedImage.getGraphics();
        //  填充背景颜色
        g.setColor(Color.white);
        g.fillRect(0, 0, width, height);
        //  绘制边框
        g.setColor(Color.red);
        g.drawRect(0, 0, width - 1, height - 1);
        //  生成随机字符
        //  准备数据
        String data = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";
        //  准备随机对象
        Random r = new Random();
        //  声明一个变量 保存验证码
        String code = "";
        //  书写4个随机字符
        for (int i = 0; i < 4; i++) {
            //  设置字体
            g.setFont(new Font("宋体", Font.BOLD, 28));
            //  设置随机颜色
            g.setColor(new Color(r.nextInt(255), r.nextInt(255), r.nextInt(255)));

            String str = data.charAt(r.nextInt(data.length())) + "";
            g.drawString(str, 10 + i * 28, 30);

            //  将新的字符 保存到验证码中
            code = code + str;
        }
        //  绘制干扰线
        for (int i = 0; i < 6; i++) {
            //  设置随机颜色
            g.setColor(new Color(r.nextInt(255), r.nextInt(255), r.nextInt(255)));

            g.drawLine(r.nextInt(width), r.nextInt(height), r.nextInt(width), r.nextInt(height));
        }

        //  将验证码 打印到控制台
        System.out.println(code);

        //  将验证码放到session中
        req.getSession().setAttribute("code_session", code);

        //  将画布显示在浏览器中
        ImageIO.write(bufferedImage, "jpg", resp.getOutputStream());
    }
}
3.2 文件下载
用户点击页面的链接，浏览器开始下载文件。
3.2.1 使用链接下载文件
1
<a href="/Day35_war_exploded/download/web.xml">Download_XML</a><br>
缺点
浏览器可识别的媒体类型，是直接打开而不是下载
不能判断用户是否登录(vip)，进行限制

3.2.2 使用Servlet下载文件
二个响应头二个字节流

说明	API
被下载文件的字节输入流	FileInputStream
response字节输出流	response字节输出流
告知客户端下载文件的MIME类型	Content-Type:MIME类型
告知浏览器以附件的方式保存	Content-Disposition:attachment;filename=文件名
1
<a href="/Day35_war_exploded/DownloadServlet?filename=web.xml">Download_XML</a><br>
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
@WebServlet("/DownloadServlet")
public class DownloadServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //获取文件名
        String filename = req.getParameter("filename");
        //获取文件真实路径，封装字节输入流
        ServletContext servletContext = req.getServletContext();
        String realPath = servletContext.getRealPath("/download/" + filename);
        FileInputStream in = new FileInputStream(realPath);

        //告诉浏览器下载文件MIME类型 Content-Type
        String mimeType = servletContext.getMimeType(filename);
        resp.setContentType(mimeType);

        //告知浏览器以附件的方式保存 Content-Disposition:attachment;filename=文件名
        //解决中文乱码和浏览器兼容性
        String userAgent = req.getHeader("user-agent");
        //调用工具处理
        filename=DownLoadUtils.getName(userAgent,filename);
        resp.setHeader("content-disposition", "attachment;filename=" + filename);

//        resp.setHeader("Content-Disposition", "attachment;filename=" + filename);
        //获取response的字节输出流
        ServletOutputStream out = resp.getOutputStream();
        //IO流Copy
//        byte[] bys = new byte[1024];
//        int len = 0;
//        while ((len = in.read(bys)) != -1) {
//            out.write(bys, 0, len);
//        }
        IoUtil.copy(in,out);
        //释放资源
        out.close();//可以交给Tomcat关闭
        in.close();
    }
}
中文乱码问题
如果该下载文件名是中文的话，会出现乱码…
谷歌和绝大多数的浏览器是通过 url编码
URLEncode() 编码
URLDecode() 解码
火狐浏览器 base64编码
如下工具包解决乱码问题:
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
public class DownLoadUtils {

	public static String getName(String agent, String filename) throws UnsupportedEncodingException {
		if (agent.contains("Firefox")) {
			// 火狐浏览器
			BASE64Encoder base64Encoder = new BASE64Encoder();
			filename = "=?utf-8?B?" + base64Encoder.encode(filename.getBytes("utf-8")) + "?=";
		} else {
			// 其它浏览器
			filename = URLEncoder.encode(filename, "utf-8");
		}
		return filename;
	}
}
3.2.2.1 hutool工具包
官网:https://www.hutool.cn/

hutool-all-5.2.3.jar
总结
一 ServletContext
概述
代表当前web项目对象
主要作用
共享数据（域对象）

获取资源文件在服务器上真实路径

获取全局的配置参数

web.xml中配置
获取文件MIME类型

互联网传输数据时，识别文件的类型
案例：统计网站的访问次数
二 Response
概述
开发人员可以使用response对象的方法，设置要返回给浏览器的响应信息
Response设置响应消息
设置响应行

void setStatus(int sc)
设置响应头

void setHeader(String name, String value)
设置响应体

ServletOutputStream getOutputStream() 字节输出流
PrintWriter getWriter() 字符输出流
响应重定向
转发与重定向的区别

转发

地址栏： 没有改变
浏览器： 发了一次请求
服务器： 只有一对请求和响应对象
发生的位置： 服务器
重定向

地址栏： 发生了改变
浏览器： 发了两次请求
服务器： 有两对请求和响应对象
发生的位置： 浏览器
响应定时刷新
响应中文
response.setContentType(“text/html;charset=utf-8”);
三 综合案例
点击切换验证码
随机数欺骗浏览器
文件下载
解决了中文编码
hutool工具包
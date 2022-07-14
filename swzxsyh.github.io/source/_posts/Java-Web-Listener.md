---
title: Java Web - Listener
date: 2020-04-25 01:29:53
tags:
---

一.Linstener
1.1 概述
中的监听器(观察者模式)
Java程序中，也要需要被监视的对象，一旦被监视对象发生变化，采取相应对象

监听器三大对象
HttpServletRequest,HttpSession,ServletContext

场景
历史访问次数，统计在线人数，系统启动时初始化配置信息

1.2 快速入门
使用ServletContextListener箭头项目启动和销毁做一些事，如在项目启动时加载配置文件
步骤:

创建ServletContextListener普通类
监听ServletContext创建、销毁
配置web.xml/注解
补充:监听HttpServletRequestListener/HttpSessionListener

web.xml

```xml
<listener>
    <listener-class>com.test.Demo01.MyListener</listener-class>
</listener>
```

```java

public class MyListener implements ServletContextListener {
  //监听ServletContext创建
  @Override
  public void contextInitialized(ServletContextEvent servletContextEvent) {
    System.out.println("ServletContext创建");
  }
  //监听ServletContext销毁
  @Override
  public void contextDestroyed(ServletContextEvent servletContextEvent) {
    System.out.println("ServletContext销毁");
  }
}
```

注解


```java
@WebListener
public class MyListener implements ServletContextListener {
  //监听ServletContext创建
  @Override
  public void contextInitialized(ServletContextEvent servletContextEvent) {
    System.out.println("ServletContext创建");
  }
  //监听ServletContext销毁
  @Override
  public void contextDestroyed(ServletContextEvent servletContextEvent) {
    System.out.println("ServletContext销毁");
  }
}
```
1.3 模拟Spring框架
ServletContext可以在项目启动时读取配置文件加载

```xml
<!--    全局配置参数-->
<context-param>
  <param-name>configLocation</param-name>
  <param-value>words.properties</param-value>
</context-param>
```




```java

@WebListener
public class MyListener implements ServletContextListener {
  //监听ServletContext创建
  @Override
  public void contextInitialized(ServletContextEvent servletContextEvent) {
    System.out.println("ServletContext创建");
    //可以加载公司定义配置文件的名称
    //servletContextEvent 上下文事件对象，获取ServletContext
    ServletContext servletContext = servletContextEvent.getServletContext();
    //通过加载定义公司定义的配置文件名称
    String configLoaction = servletContext.getInitParameter("configLocation");
    System.out.println("" + configLoaction);
  }

  //监听ServletContext销毁
  @Override
  public void contextDestroyed(ServletContextEvent servletContextEvent) {
    System.out.println("ServletContext销毁");
  }
}
```

1.4 案例统计在线人数
需求:
有用户使用网站: 在线人数+1,用户退出，在线人数-1

步骤分析
使用ServletContext域对象存储在线总人数
使用ServletContextListener在项目启动时，初始化总人数为0
使用HttpSessionListener监听器，用户访问，人数+1，用户退出，人数-1
使用LogoutServlet控制器对当前会话对Session手动销毁

代码实现

InitNumberListerner

```java
@WebListener
public class InitNumberListerner implements ServletContextListener {
  @Override
  public void contextInitialized(ServletContextEvent servletContextEvent) {
    //获取上下文域对象
    ServletContext servletContext = servletContextEvent.getServletContext();
    //初始化在线人数
    servletContext.setAttribute("number",0);
  }
  @Override
  public void contextDestroyed(ServletContextEvent servletContextEvent) {

  }
}
```
NumberChangeListener


```java
@WebListener
public class NumberChangeListener implements HttpSessionListener {
  //会话建立，在线人数+1
  @Override
  public void sessionCreated(HttpSessionEvent httpSessionEvent) {
    //获取session
    HttpSession session = httpSessionEvent.getSession();
    //获取上下文session域对象
    ServletContext servletContext = session.getServletContext();
    //取出在线人数
    Integer number = (Integer) servletContext.getAttribute("number");
    //+1
    servletContext.setAttribute("number", number + 1);
  }
  //会话销毁，在线人数-1
  @Override
  public void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
    //获取session
    HttpSession session = httpSessionEvent.getSession();
    //获取上下文session域对象
    ServletContext servletContext = session.getServletContext();
    //取出在线人数
    Integer number = (Integer) servletContext.getAttribute("number");
    //-1
    servletContext.setAttribute("number", number - 1);
  }
}
```

index.jsp

```jsp
<body>

  <h3>Learn Listener</h3>
  <h5>Online Member:${applicationScope.number}</h5>

  <a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a>
  $END$
</body>
```

LogoutServlet


```java
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //销毁Session
    req.getSession().invalidate();
    resp.getWriter().write("Logout");
  }
}
```

二.综合案例
2.1 环境搭建



```java
public class User {
  private String id;
  private String name;
  private String sex;
  private Integer age;
  private String address;
  private String qq;
  private String email;
}

@WebFilter("/*")
public class EncodeFilter implements Filter {
  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
  }

  @Override
  public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    HttpServletRequest request = (HttpServletRequest) servletRequest;
    HttpServletResponse response = (HttpServletResponse) servletResponse;
    if (request.getMethod().equalsIgnoreCase("post")) {
      request.setCharacterEncoding("UTF-8");
    }
    filterChain.doFilter(request, response);
  }

  @Override
  public void destroy() {

  }
}


public class DataUtils {
  private static String realpath = "/Users/swzxsyh/Program/userdata.txt";

  //从文件中读取所有学员信息
  public static List<User> readAll() {
    //保存所有学生对象信息
    List<User> list = new ArrayList<>();
    try {
      //得到文件真实路径
      //创建字符输入流
      Reader isr = new InputStreamReader(new FileInputStream(realpath), "UTF-8");
      //创建字符缓冲流
      BufferedReader br = new BufferedReader(isr); //装饰模式
      //一次读一行
      String row = null;
      while ((row = br.readLine()) != null) {//row = "1,张三,男,20"
        String[] arr = row.split(",");
        User user = new User();
        user.setId(arr[0]);
        user.setName(arr[1]);
        user.setSex(arr[2]);
        user.setAge(Integer.parseInt(arr[3]));
        user.setAddress(arr[4]);
        user.setQq(arr[5]);
        user.setEmail(arr[6]);
        //将User对象添加到集合
        list.add(user);
      }
      br.close();
    } catch (Exception e) {
      e.printStackTrace();
    }

    return list;
  }

  //向文件中写入所有用户信息--覆盖写
  public static void writeAll(List<User> list) {
    try {
      //创建字符输出流
      Writer osw = new OutputStreamWriter(new FileOutputStream(realpath), "UTF-8");
      //创建字符缓冲流
      BufferedWriter out = new BufferedWriter(osw);
      //循环向文件中写入文本
      for (User user : list) {
        out.write(user.getId() + "," + user.getName() + "," + user.getSex() + "," + user.getAge() + "," + user.getAddress() + "," + user.getQq() + "," + user.getEmail());
        out.newLine();//创建新的一行
      }
      out.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  public static void main(String[] args) {
    List<User> list = readAll();

  }
}
```

2.2 用户查询功能



```java
@WebServlet("/FindAllServlet")
public class FindAllServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    UserService userService = new UserService();
    List<User> list = userService.findAll();
    req.setAttribute("list", list);
    req.getRequestDispatcher("/list.jsp").forward(req, resp);
  }
}

public class UserService {
  UserDao userDao = new UserDao();
  public List<User> findAll() {

    return userDao.findAll();
  }


  public class UserDao {
    public List<User> findAll() {
      List<User> list = DataUtils.readAll();
      return list;
    }
```


2.3 添加用户功能

```java
public class AddServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    try {
      Map<String, String[]> parameterMap = req.getParameterMap();
      User user = new User();
      BeanUtils.populate(user,parameterMap);
      UserService userService = new UserService();
      userService.add(user);
      resp.sendRedirect(req.getContextPath()+"/FindAllServlet");
    } catch (IllegalAccessException e) {
      e.printStackTrace();
    } catch (InvocationTargetException e) {
      e.printStackTrace();
    }
  }
}

public void add(User user) {
  userDao.add(user);
}

public void add(User user) {
  List<User> list = DataUtils.readAll();
  list.add(user);
  DataUtils.writeAll(list);
}
```
2.4 删除用户功能

```java

@WebServlet("/DeleteServlet")
public class DeleteServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String id = req.getParameter("id");
    UserService userService = new UserService();
    userService.delete(id);
    resp.sendRedirect(req.getContextPath()+"/FindAllServlet");
  }}

public void delete(String id){
  userDao.delete(id);
}

public void delete(String id) {
  List<User> list = DataUtils.readAll();
  for (User user : list) {
    if (user.getId().equalsIgnoreCase(id)) {
      list.remove(user);
      break;
    }
  }
  DataUtils.writeAll(list);
}
```
2.5 修改用户功能
2.5.1 用户回显

```java
@WebServlet("/FindByIdServlet")
public class FindByIdServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String id = req.getParameter("id");
    UserService userService = new UserService();
    User user = userService.fidById(id);
    req.setAttribute("user", user);
    req.getRequestDispatcher("/update.jsp").forward(req, resp);
  }}
public User fidById(String id) {
    return userDao.findById(id);
}

public User findById(String id) {
    User returnUser = null;
    List<User> list = DataUtils.readAll();
    for (User user : list) {
        if (user.getId().equalsIgnoreCase(id)) {
            returnUser = user;
        }
    }
    return returnUser;
}

```
2.5.2 修改用户

​    

```java
@WebServlet("/UpdateServlet")
public class UpdateServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doPost(req, resp);
  }@Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    try {
      Map<String, String[]> parameterMap = req.getParameterMap();
      User newUser = new User();
      BeanUtils.populate(newUser, parameterMap);
      UserService userService = new UserService();
      userService.update(newUser);
      resp.sendRedirect(req.getContextPath() + "/FindAllServlet");
    } catch (IllegalAccessException e) {
      e.printStackTrace();
    } catch (InvocationTargetException e) {
      e.printStackTrace();
    }

  }
}

public void update(User newUser) {
  userDao.update(newUser);
}


public void update(User newUser) {
  List<User> list = DataUtils.readAll();
  for (User user : list) {
    if (user.getId().equalsIgnoreCase(newUser.getId())) {
      try {
        BeanUtils.copyProperties(user, newUser);
      } catch (IllegalAccessException e) {
        e.printStackTrace();
      } catch (InvocationTargetException e) {
        e.printStackTrace();
      }
    }
  }
  DataUtils.writeAll(list);
}
```



总结
listener
概述
监听web三大域对象：Request、Session、ServletContext（创建和销毁）
作用
历史访问次数
统计在线人数
系统启动时初始化配置信息
快速入门
定义一个类，实现ServletContextListener接口
重写接口中的方法
配置

web.xml

别人写好的监听器，只能通过配置文件进行配置
注解

案例:统计在线人数
1）初始化在线人数
2）创建会话时人数+1，关闭会话时人数-1
3）servlet实现用户退出
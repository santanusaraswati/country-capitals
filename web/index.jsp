<%--
  Created by IntelliJ IDEA.
  User: santanu
  Date: 11/18/19
  Time: 8:13 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.bits.wilp.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Objects" %>
<%! CountryList countryList = new CountryList(); %>
<html class="game" lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

  <%
    if (!countryList.isInitialized()) {
      countryList.init(application.getResource("/WEB-INF/country-list.csv"));
    }
    Integer streak = (Integer) session.getAttribute("streak");
    Integer record = (Integer) session.getAttribute("record");
    if (streak == null) {
      streak = 0;
      session.setAttribute("streak", streak);
    }
    if (record == null) {
      record = 0;
      session.setAttribute("record", record);
    }

    String filter = request.getParameter("f");
    if (filter != null) {
      session.setAttribute("f", filter);
    }

    String option = request.getParameter("o");
    if (option != null) {
        session.setAttribute("o", option);
    }

    String question = request.getParameter("q");
    String selected = request.getParameter("c");
    Country askedCountry = null;
    Country selectedCountry = null;
    Boolean correct = null;
    if (question != null && selected != null) {
      try {
        askedCountry = countryList.countryById(Integer.parseInt(question));
        selectedCountry = countryList.countryById(Integer.parseInt(selected));
        correct = Objects.equals(askedCountry, selectedCountry);
        if (correct) {
          streak += 1;
          if (streak > record) {
            record = streak;
            session.setAttribute("record", record);
          }
          session.setAttribute("streak", streak);
        } else {
          streak = 0;
          session.setAttribute("streak", streak);
        }
      } catch (Exception e) {
        correct = null;
      }
    }
    int randomNumber = (int)(System.currentTimeMillis() % 4);
    String continent = (String)session.getAttribute("f");
    List<Country> options = countryList.nextBatch(((continent == null) || (continent.length() == 0))?"world":continent);
    Country newQuestion = options.get(randomNumber);


  %>
  <meta name="theme-color" content="#000">
  <meta name="apple-mobile-web-app-status-bar-style" content="#000">

  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">    <title>
    Capitals of Countries
  </title>
  <meta property="og:title" content="Capitals of Countries">
  <meta name="description" property="og:description" content="">
  <meta property="og:type" content="website">
  <meta property="og:url" content="http://flag-icon-css.lip.is/">
  <link rel="stylesheet" href="./static-content/style.css">

  <script charset="utf-8" src="./static-content/button.d941c9a422e2e3faf474b82a1f39e936.js"></script></head>

<body>
<div class="jumbotron text-center">
  <div class="container">
    <h1>Learn the Capitals</h1>
  </div>
  <div class="bottom">
  </div>
</div>
<div class="container">
  <div class="text-center">
    <div class="btn-group">
      <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <span class="fa"></span> Region:
      <%
        if (continent == null || continent.length() == 0) {
      %>
      World
      <%
        } else {
      %>
      <%= continent.replace("_", " ") %>
      <%
        }
      %>
      <span class="caret"></span>
      </button>
      <ul class="dropdown-menu">
        <li><a href="/index.jsp?f=World">World</a></li>
        <li role="separator" class="divider"></li>
        <li><a href="/index.jsp?f=Africa" rel="nofollow">Africa</a></li>
        <li><a href="/index.jsp?f=Asia" rel="nofollow">Asia</a></li>
        <li><a href="/index.jsp?f=Europe" rel="nofollow">Europe</a></li>
        <li><a href="/index.jsp?f=North_America" rel="nofollow">North America</a></li>
        <li><a href="/index.jsp?f=South_America" rel="nofollow">South America</a></li>
        <li><a href="/index.jsp?f=oceania" rel="nofollow">Oceania</a></li>
      </ul>
    </div>

    <div class="btn-group">
      <button type="button" class="btn btn-success dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <span class="fa"></span>
        <%
          if ("1".equals(session.getAttribute("o"))) {
        %> Find a Country
        <% } else { %>
         Find a Capital
        <% } %>
        <span class="caret"></span>
      </button>
      <ul class="dropdown-menu">
        <li><a href=<%= "/index.jsp?o=0" %> rel="nofollow">Find a Capital</a></li>
        <li><a href=<%= "/index.jsp?o=1" %> rel="nofollow">Find a Country</a></li>
      </ul>
    </div>
  </div>
  <hr>
  <div class="text-center">
    <div class="anchor" id="question"></div>

    <div id="notifications">
      <%
        if ("1".equals(session.getAttribute("o"))) {

        if (correct != null) {
          if (correct) {
      %>
      <div class="alert alert-dismissable alert-success">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
        Correct! <%= askedCountry.getCapital() %> is the capital of <%= selectedCountry.getName() %>.
      </div>
      <%
      } else {
      %>
      <div class="alert alert-dismissable alert-danger">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
        Wrong! <%= askedCountry.getCapital() %> is not the capital of <%= selectedCountry.getName() %>.
      </div>
      <% } } } else {
        if (correct != null) {
          if (correct) {
      %>
      <div class="alert alert-dismissable alert-success">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
        Correct! The capital of <%= askedCountry.getName() %> is <%= selectedCountry.getCapital() %>.
      </div>
      <%
      } else {
      %>
      <div class="alert alert-dismissable alert-danger">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
        Wrong! The capital of <%= askedCountry.getName() %> is not <%= selectedCountry.getCapital() %>.
      </div>
      <% } } } %>
    </div>
    <%
      if ("1".equals(session.getAttribute("o"))) {
    %>
    <h2><strong><%= newQuestion.getCapital() %></strong> is the capital of</h2>
    <% } else { %>
    <h2>What's the capital of <strong><%= newQuestion.getName() %></strong>?</h2>
    <% } %>
    <div class="row">
      <%
        if ("1".equals(session.getAttribute("o"))) {
      %>
      <div class="col-md-offset-4 col-md-4">
        <a class="btn btn-info btn-block btn-loading" data-loading-text="Please wait..." href=<%= "/index.jsp?q=" + newQuestion.getId() + "&c=" + options.get(0).getId() %> rel="nofollow">
          <%= options.get(0).getName() %>
        </a>
        <a class="btn btn-info btn-block btn-loading" data-loading-text="Please wait..." href=<%= "/index.jsp?q=" + newQuestion.getId() + "&c=" + options.get(1).getId() %> rel="nofollow">
          <%= options.get(1).getName() %>
        </a>
        <a class="btn btn-info btn-block btn-loading" data-loading-text="Please wait..." href=<%= "/index.jsp?q=" + newQuestion.getId() + "&c=" + options.get(2).getId() %> rel="nofollow">
          <%= options.get(2).getName() %>
        </a>
        <a class="btn btn-info btn-block btn-loading" data-loading-text="Please wait..." href=<%= "/index.jsp?q=" + newQuestion.getId() + "&c=" + options.get(3).getId() %> rel="nofollow">
          <%= options.get(3).getName() %>
        </a>
      </div>
      <% } else { %>
      <div class="col-md-offset-4 col-md-4">
        <a class="btn btn-info btn-block btn-loading" data-loading-text="Please wait..." href=<%= "/index.jsp?q=" + newQuestion.getId() + "&c=" + options.get(0).getId() %> rel="nofollow">
          <%= options.get(0).getCapital() %>
        </a>
        <a class="btn btn-info btn-block btn-loading" data-loading-text="Please wait..." href=<%= "/index.jsp?q=" + newQuestion.getId() + "&c=" + options.get(1).getId() %> rel="nofollow">
          <%= options.get(1).getCapital() %>
        </a>
        <a class="btn btn-info btn-block btn-loading" data-loading-text="Please wait..." href=<%= "/index.jsp?q=" + newQuestion.getId() + "&c=" + options.get(2).getId() %> rel="nofollow">
          <%= options.get(2).getCapital() %>
        </a>
        <a class="btn btn-info btn-block btn-loading" data-loading-text="Please wait..." href=<%= "/index.jsp?q=" + newQuestion.getId() + "&c=" + options.get(3).getId() %> rel="nofollow">
          <%= options.get(3).getCapital() %>
        </a>
      </div>
      <% } %>
    </div>
    <div class="row">
      <div class="col-md-offset-4 col-md-4">
        <div class="row">
          <div class="col-xs-6">
            <h3 class="text-success">Streak: <strong><%= session.getAttribute("streak") %></strong></h3>
          </div>
          <div class="col-xs-6">
            <h3 class="text-primary">Record: <strong><%= session.getAttribute("record") %></strong></h3>
          </div>
        </div>
      </div>
    </div>
    <hr>
  </div>
</div>
<footer class="footer">
  <div class="container">
  </div>
</footer>  <script src="./static-content/ext.js"></script>
<script src="./static-content/script.js"></script>
</body></html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    javax.servlet.http.HttpSession session = request.getSession(true);
    java.util.Date now = new java.util.Date();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Tomcat JSP Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; max-width: 900px; }
        th, td { text-align: left; padding: 6px 10px; border: 1px solid #ddd; }
        th { background: #f2f2f2; }
        pre { background:#f7f7f7; padding:10px; overflow:auto; }
    </style>
</head>
<body>
    <h1>Tomcat JSP Test</h1>
    <p>This page verifies JSP execution on the server.</p>

    <h2>Basic Info</h2>
    <table>
        <tr><th>Item</th><th>Value</th></tr>
        <tr><td>Current time</td><td><%= now.toString() %></td></tr>
        <tr><td>Server info</td><td><%= application.getServerInfo() %></td></tr>
        <tr><td>Server name</td><td><%= request.getServerName() %></td></tr>
        <tr><td>Server port</td><td><%= request.getServerPort() %></td></tr>
        <tr><td>Context path</td><td><%= request.getContextPath() %></td></tr>
        <tr><td>Request URI</td><td><%= request.getRequestURI() %></td></tr>
        <tr><td>Session ID</td><td><%= session.getId() %></td></tr>
    </table>

    <h2>System Properties</h2>
    <table>
        <tr><th>Property</th><th>Value</th></tr>
        <tr><td>Java version</td><td><%= System.getProperty("java.version") %></td></tr>
        <tr><td>Java vendor</td><td><%= System.getProperty("java.vendor") %></td></tr>
        <tr><td>OS</td><td><%= System.getProperty("os.name") %> / <%= System.getProperty("os.version") %></td></tr>
        <tr><td>User</td><td><%= System.getProperty("user.name") %></td></tr>
    </table>

    <h2>Request Headers</h2>
    <table>
        <tr><th>Header</th><th>Value</th></tr>
        <%
            java.util.Enumeration headerNames = request.getHeaderNames();
            while (headerNames.hasMoreElements()) {
                String name = (String) headerNames.nextElement();
        %>
            <tr><td><%= name %></td><td><%= request.getHeader(name) %></td></tr>
        <%
            }
        %>
    </table>

    <h2>Environment Variables (sample)</h2>
    <pre>
PATH=<%= System.getenv("PATH") %>
HOME=<%= System.getenv("HOME") %>
    </pre>

    <p style="margin-top:20px;">If this page renders, Tomcat is serving JSPs correctly.</p>
</body>
</html>
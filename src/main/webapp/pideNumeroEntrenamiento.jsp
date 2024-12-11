<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: danic
  Date: 11/12/2024
  Time: 19:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Pide Numero Entrenamiento</title>
    <link rel="stylesheet" href="estilos.css">
</head>
<body>
<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/baloncesto_servlet","root", "root");
    Statement s = conexion.createStatement();

    ResultSet listado = s.executeQuery ("SELECT * FROM entrenamiento");
%>
<table>
    <tr><th>Código</th><th>Tipo Entrenamiento</th><th>Ubicacion</th><th>Fecha Realizacion</th></tr>
    <%
        Integer entrenamientoIDADestacar = (Integer)session.getAttribute("entrenamientoIDADestacar");
        String claseDestacar = "";
        while (listado.next()) {
            claseDestacar = (entrenamientoIDADestacar != null
                    && entrenamientoIDADestacar==listado.getInt("id") ) ?
                    "destacar" :  "";

    %>


    <tr class="<%= claseDestacar%>" >
        <td >
            <%=listado.getInt("id")%>
        </td>
        <td><%=listado.getString("tipo_entrenamiento")%>
        </td>
        <td><%=listado.getString("ubicacion")%>
        </td>
        <td><%=listado.getString("fecha_realizacion")%>
        </td>
        <td>
            <form method="get" action="borraEntrenamiento.jsp">
                <input type="hidden" name="codigo" value="<%=listado.getString("id") %>"/>
                <input type="submit" value="borrar">
            </form>
        </td>
    </tr>
    <%
        } // while
        conexion.close();
    %>
</table>
<button><a href="index.jsp">Volver a Inicio</a></button>
</body>
</html>

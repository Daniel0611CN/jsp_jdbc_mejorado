<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Listado Entrenamiento</title>
</head>
<body>
<h1>Listado de Entrenamiento</h1>
<%
    //CARGA DEL DRIVER Y PREPARACIÓN DE LA CONEXIÓN CON LA BBDD
    //						v---------UTILIZAMOS LA VERSIÓN MODERNA DE LLAMADA AL DRIVER, no deprecado
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/baloncesto_servlet","root", "root");

    //UTILIZAR STATEMENT SÓLO EN QUERIES NO PARAMETRIZADAS.
    Statement s = conexion.createStatement();
    ResultSet listado = s.executeQuery ("SELECT * FROM entrenamiento");

    while (listado.next()) {
        out.println(listado.getString("id") + " " + listado.getString ("tipo_entrenamiento") + "<br>");
    }
    listado.close();
    s.close();
    conexion.close();
%>
<button><a href="index.jsp">Volver a Inicio</a></button>
</body>
</html>
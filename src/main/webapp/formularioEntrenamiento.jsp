<%--
  Created by IntelliJ IDEA.
  User: danic
  Date: 11/12/2024
  Time: 12:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Crear Entrenamiento Para Socio</title>
</head>
<body>
    <form method="post" action="grabaEntrenamiento.jsp">
        ID
        <input type="number" name="id">
        <br>
        Tipo de Entrenamiento(fisico, técnico)
        <input type="text" name="tipo">
        <br>
        Ubicacion
        <input type="text" name="ubicacion">
        <br>
        Fecha de Realización
        <input type="date" name="fecha">
        <br>
        <% // Validar fecha en el servidor con el simpleDateFormat; %>
        <input type="submit" id="btn" value="Enviar Entrenamiento"></a>
    </form>
</body>
</html>

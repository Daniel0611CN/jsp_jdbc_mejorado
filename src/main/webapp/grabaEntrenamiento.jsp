<%@page import="java.sql.*" %>
<%@page import="java.util.Objects" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<%
    //CÓDIGO DE VALIDACIÓN
    boolean valida = true;
    int numero = -1;
    String tipo = null;
    String ubicacion = null;
    Date fecha = null;

    boolean flagValidaID = false;
    boolean flagValidaEntrenamientoNull = false;
    boolean flagValidaEntrenamientoBlank = false;
    boolean flagValidaUbicacionNull = false;
    boolean flagValidaUbicacionBlank = false;
    boolean flagValidaFecha = false;

    try {

        numero = Integer.parseInt(request.getParameter("id")); // si el id válido;
        flagValidaID = true;
        //UTILIZO LOS CONTRACTS DE LA CLASE Objects PARA LA VALIDACIÓN
        //             v---- LANZA NullPointerException SI EL PARÁMETRO ES NULL
        Objects.requireNonNull(request.getParameter("tipo"));
        flagValidaEntrenamientoNull = true;
        //CONTRACT nonBlank..
        //UTILIZO isBlank SOBRE EL PARÁMETRO DE TIPO String PARA CHEQUEAR QUE NO ES UN PARÁMETRO VACÍO "" NI CADENA TODO BLANCOS "    "
        //          |                                EN EL CASO DE QUE SEA BLANCO LO RECIBIDO, LANZO UNA EXCEPCIÓN PARA INVALIDAR EL PROCESO DE VALIDACIÓN
        //          -------------------------v                      v---------------------------------------|
        if (request.getParameter("tipo").isBlank()) throw new RuntimeException("Parámetro vacío o todo espacios blancos.");
        if (!request.getParameter("tipo").equalsIgnoreCase("fisico") && !request.getParameter("tipo").equalsIgnoreCase("tecnico")) throw new RuntimeException("Parámetro no válido");
        flagValidaEntrenamientoBlank = true;
        tipo = request.getParameter("tipo");

        Objects.requireNonNull(request.getParameter("ubicacion"));
        flagValidaUbicacionNull = true;

        if (request.getParameter("ubicacion").isBlank()) throw new RuntimeException("Parámetro vacío o todo espacios blancos.");
        flagValidaUbicacionBlank = true;
        ubicacion = request.getParameter("ubicacion");

        String fechaStr = request.getParameter("fecha");

        if (fechaStr == null) throw new RuntimeException("Parámetro vacío o todo espacios blancos.");
        if (request.getParameter("fecha").isBlank()) throw new RuntimeException("Parámetro vacío o todo espacios blancos.");
        flagValidaFecha = true;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setLenient(false);

        try {
            fecha = sdf.parse(fechaStr);
        } catch (Exception e) {
            throw new RuntimeException("Fecha no válida.");
        }

    } catch (Exception ex) {
        ex.printStackTrace();

        if (!flagValidaID) {
            session.setAttribute("error", "Error en id.");
        } else if (!flagValidaEntrenamientoNull || !flagValidaEntrenamientoBlank) {
            session.setAttribute("error", "Error en tipo de entrenamiento.");
        } else if (!flagValidaUbicacionNull || !flagValidaUbicacionBlank) {
            session.setAttribute("error", "Error en ubicacion.");
        } else if (!flagValidaFecha) {
            session.setAttribute("error", "Error en estatura.");
        }

        valida = false;
    }
    //FIN CÓDIGO DE VALIDACIÓN

    if (valida) { // si valida es true;

        Connection conn = null;
        PreparedStatement ps = null;
// 	ResultSet rs = null;

        try {

            //CARGA DEL DRIVER Y PREPARACIÓN DE LA CONEXIÓN CON LA BBDD
            //						v---------UTILIZAMOS LA VERSIÓN MODERNA DE LLAMADA AL DRIVER, no deprecado
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/baloncesto_servlet", "root", "root");


//>>>>>>NO UTILIZAR STATEMENT EN QUERIES PARAMETRIZADAS
//       Statement s = conexion.createStatement();
//       String insercion = "INSERT INTO socio VALUES (" + Integer.valueOf(request.getParameter("numero"))
//                          + ", '" + request.getParameter("nombre")
//                          + "', " + Integer.valueOf(request.getParameter("estatura"))
//                          + ", " + Integer.valueOf(request.getParameter("edad"))
//                          + ", '" + request.getParameter("localidad") + "')";
//       s.execute(insercion);
//<<<<<<

            String sql = "INSERT INTO entrenamiento VALUES ( " +
                    "?, " + //id
                    "?, " + //tipo
                    "?, " + //ubicacion
                    "?)"; //fecha

            ps = conn.prepareStatement(sql);
            int idx = 1;
            ps.setInt(idx++, numero);
            ps.setString(idx++, tipo);
            ps.setString(idx++, ubicacion);
            ps.setString(idx, String.valueOf(new java.sql.Date(fecha.getTime())));

            int filasAfectadas = ps.executeUpdate();
            System.out.println("SOCIOS GRABADOS:  " + filasAfectadas);

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            //BLOQUE FINALLY PARA CERRAR LA CONEXIÓN CON PROTECCIÓN DE try-catch
            //SIEMPRE HAY QUE CERRAR LOS ELEMENTOS DE LA  CONEXIÓN DESPUÉS DE UTILIZARLOS
            //try { rs.close(); } catch (Exception e) { /* Ignored */ }
            try {
                ps.close();
            } catch (Exception e) { /* Ignored */ }
            try {
                conn.close();
            } catch (Exception e) { /* Ignored */ }
        }

        //out.println("Socio dado de alta.");

        //response.sendRedirect("detalleSocio.jsp?socioID="+numero);
        //response.sendRedirect("pideNumeroSocio.jsp?socioIDADestacar="+numero);
        session.setAttribute("entrenamientoIDADestacar", numero);
        response.sendRedirect("pideNumeroEntrenamiento.jsp");

    } else {
        //out.println("Error de validación!");
        response.sendRedirect("formularioEntrenamiento.jsp"); // Aquí es donde llama al formularioSocio en caso de error de validación;
    }
%>
</body>
</html>

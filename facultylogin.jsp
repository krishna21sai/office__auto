<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String employeeCode = request.getParameter("employeeCode");
    String password = request.getParameter("password"); 

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/officeAuto", "root", "root");
        pstmt = conn.prepareStatement("SELECT * FROM employee_details WHERE employee_code = ? AND password = ?"); // Assuming there's a password column
        pstmt.setString(1, employeeCode);
        pstmt.setString(2, password);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            HttpSession session = request.getSession();
            session.setAttribute("employeeCode", rs.getString("employee_code"));
            session.setAttribute("employeeName", rs.getString("employee_name"));
            session.setAttribute("dateOfJoining", rs.getDate("date_of_joining"));
            session.setAttribute("role", rs.getInt("designation"));
            response.sendRedirect("leaveApplicationForm.jsp");
        } else {
            out.println("Invalid login credentials");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>

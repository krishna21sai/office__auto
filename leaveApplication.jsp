<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Application Form</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Leave Application Form</h2>
        <form action="submitLeaveApplication.jsp" method="post">
            <div class="input-group">
                <label for="employeeCode">Employee Code</label>
                <input type="text" id="employeeCode" name="employeeCode" value="<%= session.getAttribute("employeeCode") %>" readonly>
            </div>
            <div class="input-group">
                <label for="employeeName">Employee Name</label>
                <input type="text" id="employeeName" name="employeeName" value="<%= session.getAttribute("employeeName") %>" readonly>
            </div>
            <div class="input-group">
                <label for="dateOfJoining">Date of Joining Service at VEU/VU</label>
                <input type="date" id="dateOfJoining" name="dateOfJoining" value="<%= session.getAttribute("dateOfJoining") %>" readonly>
            </div>
            <div class="input-group">
                <label for="role">Role</label>
                <select id="role" name="role" required>
                    <option value="<%= session.getAttribute("role") %>">
                        <%
                            // Retrieve role details based on session attribute
                            Connection conn = null;
                            PreparedStatement pstmt = null;
                            ResultSet rs = null;
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/officeauto", "root", "root");
                                pstmt = conn.prepareStatement("SELECT designation, department FROM designation1 WHERE snno = ?");
                                pstmt.setInt(1, (Integer)session.getAttribute("role"));
                                rs = pstmt.executeQuery();
                                if (rs.next()) {
                                    out.println(rs.getString("designation") + " - " + rs.getString("department"));
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                                if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                            }
                        %>
                    </option>
                </select>
            </div>
            <div class="input-group">
                <label for="adjustment">Work Adjustment</label>
                <select id="adjustment" name="adjustment" required>
                    <option value="">Select Adjustment</option>
                </select>
            </div>
            <button type="submit">Submit</button>
        </form>
    </div>

    <script>
        function loadAdjustmentOptions() {
            const roleId = document.getElementById("role").value;
            const adjustmentSelect = document.getElementById("adjustment");
            adjustmentSelect.innerHTML = "<option value=''>Select Adjustment</option>";
            
            if (roleId) {
                fetch(`getAdjustments.jsp?roleId=${roleId}`)
                    .then(response => response.json())
                    .then(data => {
                        data.forEach(adjustment => {
                            const option = document.createElement("option");
                            option.value = adjustment.id;
                            option.text = adjustment.name;
                            adjustmentSelect.appendChild(option);
                        });
                    });
            }
        }
    </script>
</body>
</html>

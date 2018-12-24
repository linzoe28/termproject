/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.termproject;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author lendle
 */
@WebServlet(name = "PlaceSetServlet", urlPatterns = {"/placeset"})
public class PlaceSetServlet extends HttpServlet {

    static {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(PlaceSetServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
        response.setContentType("application/json;Charset=UTF-8");
        try (PrintWriter out = response.getWriter(); Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/sample", "app", "app")) {
            Statement stmt = conn.createStatement();
            ResultSet res = stmt.executeQuery("select * from pc_place where vacancy=1");
            List list = new Vector();

            while (res.next()) {
                String pc_id = res.getString("pc_id");
                String vacancy = res.getString("vacancy");
                Map map = new HashMap();
                map.put("pc_id", pc_id);
                map.put("vacancy", vacancy);
                list.add(map);
            }
            Gson gson = new Gson();
            String json = gson.toJson(list);
            out.print(json);
            //////////////////////////////
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");
        try (PrintWriter out = response.getWriter(); Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/sample", "app", "app")) {
            //insert the corresponding user
            String stu_name = request.getParameter("stu_name");
            String stu_id = request.getParameter("stu_id");
            String pc_id = request.getParameter("pc_id");
            PreparedStatement pstmt = conn.prepareStatement("insert into pc_place_apply(STU_NAME,STU_ID,PC_ID) values (?,?,?)");
            pstmt.setString(1, stu_name);
            pstmt.setString(2, stu_id);
            pstmt.setString(3, pc_id);
            pstmt.executeUpdate();

            PreparedStatement pstmt1 = conn.prepareStatement("update pc_place set vacancy=? where PC_ID=?");
            pstmt1.setString(1, "0");
            pstmt1.setString(2, pc_id);
            pstmt1.executeUpdate();


        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (PrintWriter out = resp.getWriter(); Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/sample", "app", "app")) {
            String pc_id = req.getParameter("pc_id");
            PreparedStatement pstmt = conn.prepareStatement("delete from pc_place_apply where pc_id=?");
            pstmt.setString(1, pc_id);
            pstmt.executeUpdate();
            
            PreparedStatement pstmt1 = conn.prepareStatement("update pc_place set vacancy=? where PC_ID=?");
            pstmt1.setString(1, "1");
            pstmt1.setString(2, pc_id);
            pstmt1.executeUpdate();

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

}

package servlets;

import model.Market;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/bay")
public class BayServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path;
        if (Market.isEmptyCart(req)) {
            path = "/list";
        } else {
            path = "views/bayForm.jsp";
        }
        RequestDispatcher requestDispatcher = req.getRequestDispatcher(path);
        requestDispatcher.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (Market.doBay(req)) {
            RequestDispatcher requestDispatcher = req.getRequestDispatcher("/welcome");
            requestDispatcher.forward(req, resp);
        } else {
            doGet(req, resp);
        }
    }
}

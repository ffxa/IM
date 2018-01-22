package model;

import com.google.common.collect.HashMultiset;
import com.google.common.collect.Multiset;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class Market {

    public static final String SESSION_ATTRIBUTE_CART = "cart";
    public static final String REQUEST_ATTRIBUTE_CART_INFO = "cartInfo";
    public static final String REQUEST_ATTRIBUTE_CATALOG = "catalog";
    public static final String REQUEST_ATTRIBUTE_ALERT = "alert";
    public static final String ALERT_EMPTY_PARAMETER = "on";
    public static final String ALERT_TECH_WORK = "techWork";
    public static final String REQUEST_ATTRIBUTE_ORDERING_COMPLETE_POPUP = "isBay";
    public static final String ORDERING_SUCCESS = "true";

    //Get connection from connection pool
    private static Connection getConnection() throws NamingException, SQLException {
        InitialContext ic = new InitialContext();
        DataSource ds = (DataSource) ic.lookup("java:/comp/env/jdbc/DB");
        return ds.getConnection();
    }

    //Get catalog from DB
    private static Map<Integer, Product> getCatalog() {
        Map<Integer, Product> catalog = new HashMap<>();
        String sql_getCatalog = "SELECT * FROM jarsoft_test_task.catalog";

        try (Connection connection = getConnection()){
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(sql_getCatalog);

            while (rs.next()) {
                int id = rs.getInt(1);
                String name = rs.getString(2);
                BigDecimal price = rs.getBigDecimal(3);
                catalog.put(id, new Product(name, price));
            }

        } catch (SQLException | NamingException e) {
            e.printStackTrace();
        }
        return catalog;
    }

    //Join gatalog to cart on id=id
    public static void addCartInfo(HttpServletRequest req) {
        Map<Integer, Product> cartInfo = new HashMap<>();
        Multiset<Integer> cart = (HashMultiset<Integer>) req.getSession().getAttribute(SESSION_ATTRIBUTE_CART);
        if (cart != null) {
            Map<Integer, Product> catalog = getCatalog();
            for (Multiset.Entry<Integer> num : cart.entrySet()) {
                Product product = catalog.get(num.getElement());
                cartInfo.put(num.getElement(), product);
            }
        }
        req.setAttribute(REQUEST_ATTRIBUTE_CART_INFO, cartInfo);
    }

    //check empty cart
    public static boolean isEmptyCart(HttpServletRequest req) {
        Multiset<Integer> cart = (HashMultiset<Integer>) req.getSession().getAttribute(SESSION_ATTRIBUTE_CART);
        return cart == null || cart.isEmpty();
    }

    //If session don't contain cart, create new cart and put ot sessino
    private static void addNewCartToSession(HttpServletRequest req) {
        Multiset<Integer> cart = (HashMultiset<Integer>) req.getSession().getAttribute(SESSION_ATTRIBUTE_CART);
        if (cart == null) {
            cart = HashMultiset.create();
            req.getSession().setAttribute(SESSION_ATTRIBUTE_CART, cart);
        }
    }

    public static void addCatalogToReq(HttpServletRequest req) {
        req.setAttribute(REQUEST_ATTRIBUTE_CATALOG, getCatalog());
    }

    //Edit operation with cart
    public static void editCart(HttpServletRequest req) {
        addNewCartToSession(req);
        Integer editId = Integer.parseInt(req.getParameter("id"));
        Multiset<Integer> cart = (HashMultiset<Integer>) req.getSession().getAttribute(SESSION_ATTRIBUTE_CART);
        String operation = req.getParameter("op");
        if ("dec".equals(operation)) {
            int count = cart.count(editId);
            count--;
            cart.setCount(editId, count);
        } else if ("inc".equals(operation)) {
            cart.add(editId);
        } else if ("del".equals(operation)) {
            cart.setCount(editId,0);
        } else if ("add".equals(operation)) {
            cart.add(editId);
        }
    }

    //ordering
    public static boolean doBay(HttpServletRequest req) {
        String firstname = req.getParameter("firstname");
        String lastname = req.getParameter("lastname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        if (firstname.isEmpty() || lastname.isEmpty() || email.isEmpty() || phone.isEmpty()) {
            req.setAttribute(REQUEST_ATTRIBUTE_ALERT, ALERT_EMPTY_PARAMETER);
            return false;
        } else if (!addNewOrderToDB(req, firstname, lastname, email, phone)) {
            req.setAttribute(REQUEST_ATTRIBUTE_ALERT, ALERT_TECH_WORK);
            return false;
        }

        req.getSession().invalidate();
        req.setAttribute(REQUEST_ATTRIBUTE_ORDERING_COMPLETE_POPUP, ORDERING_SUCCESS);
        return true;
    }

    private static boolean addNewOrderToDB(HttpServletRequest req, String firstname, String lastname, String email, String phone) {
        boolean success = false;
        try (Connection connection = getConnection()){
            connection.setAutoCommit(false);
            //-------------- insert in customer-------------------
            String sql_insert = "INSERT INTO jarsoft_test_task.custumers (firstname, lastname, email, phone) VALUES (?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql_insert, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, firstname);
            statement.setString(2, lastname);
            statement.setString(3, email);
            statement.setString(4, phone);
            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating customer failed, no rows affected.");
            }

            Long customerId;
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    customerId = generatedKeys.getLong(1);
                }
                else {
                    throw new SQLException("Creating user failed, no ID obtained.");
                }
            }
            //-------------- insert in order-------------------
            sql_insert = "INSERT INTO jarsoft_test_task.orders (id_customer) VALUES (?)";
            statement = connection.prepareStatement(sql_insert, Statement.RETURN_GENERATED_KEYS);
            statement.setLong(1, customerId);

            affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }

            Long orderId;
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    orderId = generatedKeys.getLong(1);
                }
                else {
                    throw new SQLException("Creating order failed, no ID obtained.");
                }
            }
            //-------------- insert in order info-------------------
            Multiset<Integer> cart = (HashMultiset<Integer>) req.getSession().getAttribute(SESSION_ATTRIBUTE_CART);
            sql_insert = "INSERT INTO jarsoft_test_task.order_info (id_order, id_catalog, quantity) VALUES (?, ? , ?)";
            int added = 0;
            for(Multiset.Entry<Integer> num : cart.entrySet()) {
                Integer productId = num.getElement();
                Integer quantity = num.getCount();
                statement = connection.prepareStatement(sql_insert, Statement.RETURN_GENERATED_KEYS);
                statement.setLong(1, orderId);
                statement.setInt(2, productId);
                statement.setInt(3, quantity);
                added += statement.executeUpdate();
            }
            if (added != cart.entrySet().size()) {
                throw new SQLException("Add orderInfo failed, no rows affected.");
            }
            //----------------commit----------------------------
            connection.commit();
            success = true;
        } catch (SQLException | NamingException e) {
            //e.printStackTrace();
        }
        return success;
    }
}

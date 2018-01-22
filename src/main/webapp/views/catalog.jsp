<%@ page import="model.Product" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.google.common.collect.HashMultiset" %>
<%@ page import="model.Market" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Catalog</title>
        <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    </head>

    <style>
        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        td, th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        tr:nth-child(even) {
            background-color: #dddddd;
        }
    </style>

    <body class="w3-light-grey">
        <div class="w3-container w3-blue-grey w3-opacity w3-center">
            <h1>Products</h1>
        </div>

        <div class="w3-bar w3-padding-large w3-padding-24">
            <button class="w3-btn w3-hover-light-blue w3-round-large" onclick="location.href='welcome'">Home</button>
            <%
                HashMultiset<Integer> cart = (HashMultiset<Integer>) session.getAttribute(Market.SESSION_ATTRIBUTE_CART);
                if (cart == null || cart.isEmpty()) {
                    out.println("<button class=\"w3-btn w3-hover-green w3-round-large\" onclick=\"location.href='cart'\" disabled>");
                    out.println("Cart (0)");
                    out.println("</button>");
                } else {
                    out.println("<button class=\"w3-btn w3-hover-green w3-round-large\" onclick=\"location.href='cart'\">");
                    out.println("Cart (" + cart.entrySet().size() + ")");
                    out.println("</button>");
                }
            %>
        </div>

        <div>
            <div>
                <%
                    Map<Integer, Product> catalog = (HashMap<Integer, Product>) request.getAttribute(Market.REQUEST_ATTRIBUTE_CATALOG);

                    if (catalog != null && !catalog.isEmpty()) {
                %>
                <table>
                    <tr>
                        <td><b>№</b></td>
                        <td><b>Name</b></td>
                        <td><b>Price</b></td>
                        <td><b>Cart</b></td>
                    </tr>
                    <%
                        int i = 1;
                        for (Map.Entry<Integer, Product> entry : catalog.entrySet()) {
                            Integer id = entry.getKey();
                            Product product = entry.getValue();
                    %>
                    <tr>
                        <td><%= i %></td>
                        <td><%= product.getName() %></td>
                        <td><%= product.getPrice() %></td>
                        <td>
                            <form id="addForm<%=id%>" action="editCart" method="post">
                                <input type="hidden" name="id" value="<%=id%>">
                                <input type="hidden" name="op" value="add">
                                <a onclick=document.getElementById("addForm<%=id%>").submit()>
                                    <span class="glyphicon glyphicon-shopping-cart"></span>
                                </a>
                            </form>
                        </td>
                    </tr>
                    <% i++;
                        } %>
                </table>
                <%
                    } else {
                        out.println("<p>Catalog is empty</p>");
                    }
                %>
            </div>
        </div>
    </body>
</html>

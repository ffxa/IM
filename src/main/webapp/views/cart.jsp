<%@ page import="model.Product" %>
<%@ page import="com.google.common.collect.Multiset" %>
<%@ page import="com.google.common.collect.HashMultiset" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="model.Market" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Cart</title>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

</head>

<style>
    table {
        font-family: arial, sans-serif;
        border-collapse: collapse;
        width: 100%;
    }

    td, th {
        border: 1px solid #dddddd;
        text-align: center;
        padding: 8px;
    }

    tr:nth-child(even) {
        background-color: #dddddd;
    }

</style>

<body class="w3-light-grey">
<div class="w3-container w3-blue-grey w3-opacity w3-center">
    <h1>Products in cart</h1>
</div>

<div class="w3-bar w3-padding-large w3-padding-24">
    <button class="w3-btn w3-hover-light-blue w3-round-large" onclick="location.href='welcome'">Home</button>
    <button class="w3-btn w3-hover-green w3-round-large" onclick="location.href='list'">Catalog</button>
    <%
        Multiset<Integer> cart = (HashMultiset) session.getAttribute(Market.SESSION_ATTRIBUTE_CART);
        if (cart != null && !cart.isEmpty()) {
            out.print("<button class=\"w3-btn w3-lime w3-round-large w3-right\" onclick=\"location.href='bay'\">Bay</button>");
    %>
</div>

<div>
    <div>
        <table>
            <tr>
                <td><b>№</b></td>
                <td><b>Name</b></td>
                <td><b>Price</b></td>
                <td><b>Quantity</b></td>
                <td><b>Cost</b></td>
                <td><b>Del</b></td>
            </tr>
            <%
                HashMap<Integer, Product> cartInfo = (HashMap<Integer, Product>) request.getAttribute(Market.REQUEST_ATTRIBUTE_CART_INFO);
                int i = 0;
                BigDecimal totalCost = new BigDecimal(0);
                for(Multiset.Entry<Integer> num : cart.entrySet()) {
                    Integer numId = num.getElement();
                    Product product = cartInfo.get(numId);
                    int count = num.getCount();
                    BigDecimal cost = product.getPrice().multiply(BigDecimal.valueOf(count));
                    totalCost = totalCost.add(cost);
                    i++;
            %>
            <tr>
                <td><%= i %></td>
                <td><%= product.getName() %></td>
                <td><%= product.getPrice() %></td>
                <td>
                    <table>
                        <tr>
                            <td>
                                <form id="decForm<%=numId%>" action="editCart" method="post">
                                    <input type="hidden" name="id" value="<%=numId%>">
                                    <input type="hidden" name="op" value="dec">
                                    <a onclick=document.getElementById("decForm<%=numId%>").submit()>
                                        <span class="fa fa-minus-square-o" style="font-size:24px"></span>
                                    </a>
                                </form>
                            </td>
                            <td><%= count %></td>
                            <td>
                                <form id="incForm<%=numId%>" action="editCart" method="post">
                                    <input type="hidden" name="id" value="<%=numId%>">
                                    <input type="hidden" name="op" value="inc">
                                    <a onclick=document.getElementById("incForm<%=numId%>").submit()>
                                        <span class="fa fa-plus-square-o" style="font-size:24px"></span>
                                    </a>
                                </form>
                            </td>
                        </tr>
                    </table>
                </td>
                <td><%= cost %></td>
                <td>
                    <form id="delForm<%=numId%>" action="editCart" method="post">
                        <input type="hidden" name="id" value="<%=numId%>">
                        <input type="hidden" name="op" value="del">
                        <a onclick=document.getElementById("delForm<%=numId%>").submit()>
                            <span class="fa fa-remove" style="font-size:48px;color:red"></span>
                        </a>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
        <%
                out.print("<h1><b>Total cost " + totalCost + "</b></h1>");
            } else {
                out.println("<p><b><i> Cart is empty</i></b></p>");
            }
        %>
    </div>
</div>

</body>
</html>

<%@ page import="com.google.common.collect.HashMultiset" %>
<%@ page import="model.Market" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <title>Bay</title>

    <script defer>
        <% String alerts = (String) request.getAttribute(Market.REQUEST_ATTRIBUTE_ALERT);
            if (Market.ALERT_EMPTY_PARAMETER.equals(alerts)) {
                out.println("alert(\"Just fill all of the fields of the form and hit Checkout button\");");
            } else if (Market.ALERT_TECH_WORK.equals(alerts)) {
                out.println("alert(\"Technical work is carried out, try later\");");
            }
        %>
    </script>
</head>
<body class="w3-light-grey">
    <div class="w3-container w3-blue-grey w3-opacity w3-center">
        <h1>Client info</h1>
    </div>
    <div class="w3-bar w3-padding-large w3-padding-24">
        <button class="w3-btn w3-hover-light-blue w3-round-large" onclick="location.href='welcome'">Home</button>
        <button class="w3-btn w3-hover-green w3-round-large" onclick="location.href='list'">Catalog</button>
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
        <form action="bay" class="w3-container w3-card-4 w3-light-grey w3-text-blue w3-margin" method="post">
            <h2 class="w3-center">Contact</h2>

            <div class="w3-row w3-section">
                <div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-user"></i></div>
                <div class="w3-rest">
                    <input class="w3-input w3-border" name="firstname" type="text" placeholder="First Name">
                </div>
            </div>

            <div class="w3-row w3-section">
                <div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-user"></i></div>
                <div class="w3-rest">
                    <input class="w3-input w3-border" name="lastname" type="text" placeholder="Last Name">
                </div>
            </div>

            <div class="w3-row w3-section">
                <div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-envelope-o"></i></div>
                <div class="w3-rest">
                    <input class="w3-input w3-border" name="email" type="text" placeholder="Email">
                </div>
            </div>

            <div class="w3-row w3-section">
                <div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-phone"></i></div>
                <div class="w3-rest">
                    <input class="w3-input w3-border" name="phone" type="text" placeholder="Phone">
                </div>
            </div>

            <button class="w3-button w3-block w3-section w3-blue w3-ripple w3-padding">Checkout</button>

        </form>
    </div>
</body>
</html>

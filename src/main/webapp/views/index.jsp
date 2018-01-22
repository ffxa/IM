<%@ page import="com.google.common.collect.HashMultiset" %>
<%@ page import="model.Market" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head>
      <meta charset="UTF-8">
      <title>Test Internet market</title>
      <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

      <script defer>
          <% String alerts = (String) request.getAttribute(Market.REQUEST_ATTRIBUTE_ORDERING_COMPLETE_POPUP);
              if (Market.ORDERING_SUCCESS.equals(alerts)) {
                  out.println("alert(\"Purchase completed successfully\");");
              }
          %>
      </script>
  </head>

  <body class="w3-light-grey">
      <div class="w3-container w3-blue-grey w3-opacity w3-center">
          <h1>Internet market</h1>
      </div>

      <div class="w3-container w3-center">
          <div class="w3-bar w3-padding-large w3-padding-24">
              <button class="w3-btn w3-hover-light-blue w3-round-large" onclick="location.href='list'">Catalog</button>
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
      </div>
  </body>
</html>

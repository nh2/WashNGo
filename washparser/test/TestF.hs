import CGI hiding (div, head, map, span)

main = run (htell <%@ include "include.html" %>)


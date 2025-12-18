from http.server import HTTPServer, SimpleHTTPRequestHandler
import ssl

httpd = HTTPServer(("0.0.0.0", 8443), SimpleHTTPRequestHandler)

ctx = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
ctx.verify_mode = ssl.CERT_REQUIRED

ctx.load_cert_chain("server.crt", "server.key")
ctx.load_verify_locations("/ca.pem")

httpd.socket = ctx.wrap_socket(httpd.socket, server_side=True)
httpd.serve_forever()

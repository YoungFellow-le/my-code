from urllib import request
from os import mkdir

URL = "https://papers.gceguide.com/A%20Levels/Computer%20Science%20(for%20first%20examination%20in%202021)%20(9618)/2021/9618_"
opener = request.URLopener()
opener.addheader('User-Agent', 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7')
session = "s"

for ses in range(1, 3):
    for var in range(1,4):
        try:
            mkdir(session.upper() + "-" + "V" + str(var))
        except FileExistsError:
            print("Directory exists")
        filename, headers = opener.retrieve(URL + session + "21_in_2" + str(var) + ".pdf", session.upper() + "-" + "V" + str(var) + "/INSERT.pdf")
        filename, headers = opener.retrieve(URL + session + "21_sf_4" + str(var) + ".zip", session.upper() + "-" + "V" + str(var) + "/SF-4.zip")
        
        for p in range(1,5):
            filename, headers = opener.retrieve(URL + session + "21_qp_" + str(p) + str(var) + ".pdf", session.upper() + "-" + "V" + str(var) + "/PAPER-" + str(p) + ".pdf")
            filename, headers = opener.retrieve(URL + session + "21_ms_" + str(p) + str(var) + ".pdf", session.upper() + "-" + "V" + str(var) + "/MS-" + str(p) + ".pdf")
    session = "w"
    

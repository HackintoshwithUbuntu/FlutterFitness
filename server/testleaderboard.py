# 1683968277729
# 1684031024786
# 1684840141210

import requests

# The start value should be adjsuted to be part of the current week
start = 1685403852075
server = "http://sdd.syedahmad.tech:8080"

fnames = ["Nettie", "Britt", "Clare", "Lynn", "Jerry", "Carey", "Julie", "Eloy", "Savannah", "Josef", "Ben"]
lnames = ["Savage", "Burgess", "Graves", "Singh", "Lin", "Edwards", "Winters", "Saunders", "Erickson", "Arroyo", "Dickens"]

unames = ["Nettie", "Britt", "Clare", "Lynn", "Jerry", "Carey", "Julie", "Eloy", "Savannah", "Josef", "Ben"]
times = ["00:01:07", "00:01:08", "00:01:09", "00:01:10", "00:01:11", "00:01:12", "00:01:13", "00:01:14", "00:01:15", "00:01:06", "00:02:06"]
distances = ["0.04", "0.05", "0.06", "0.07", "0.08", "0.09", "0.10", "0.11", "3.03", "0.12", "0.12"]
steps = ['30000', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11']

# NOTE while these accounts do have valid logins, logging into them may cause unintended behaviour due to the stripped down nature of the request being sent here

for i in range(len(fnames)):
    data = {"username": unames[i], "start": start, "timeString": times[i], "totalDistance": distances[i], "totalSteps": steps[i], "exercise": "Run", "isCheating": False}
    signup = f"{server}/signup"
    requests.post(signup, json=[unames[i], "000", fnames[i], lnames[i]])
    rundata = f"{server}/rundata"
    requests.post(rundata, json=data)
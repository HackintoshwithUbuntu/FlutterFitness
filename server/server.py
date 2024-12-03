#!/usr/bin/env python
# encoding: utf-8
import datetime
from datetime import datetime as dt
from operator import itemgetter
import json
import os
from flask import Flask, request, jsonify
from flask_cors import CORS
import geopy.distance
import pickle
import hashlib 
import shutil

# Initialise app variable
app = Flask(__name__)

# A dictionary storing usernames and passwords
logins = {}
# Dictionaries storing peoples names
fnames = {}
lnames = {}

# Dictionaries for nearby location related features
userlocations = {}
locationsettings = {}

# Dictionary for storing user country data
countrysettings = {}

# Dictionary for storing user friends
friendsettings = {}

# A utility function to check if a file exists without throwing errors
def file_exists(filename):
    try:
        my_file = open(filename)
        my_file.close()
        return True
    except:
        return False

# A utility function to allow quick updating of files
def update_file(name, obj):
    # Open file
    with open(name, 'wb+') as file:
        # Dump new data
        pickle.dump(obj, file)

# A utility function to hash things
def hasher(tohash):
    returnval = tohash
    returnval = returnval.encode("utf-8")
    # Hash it
    returnval = hashlib.sha1(returnval)
    # Storing hashed in hex form
    returnval = returnval.hexdigest()
    return returnval

# A utility function to load stored data from files or make new file if none exists
def pickle_loader(filename):
    # If file doesnt exist, create file
    if file_exists(filename) == False:
        file = open (filename, "w+")
        file.close()
    with open(filename, 'rb') as file:
        # Read file and load object
        try:
            object = pickle.load(file)
            return object
        except:
            # Empty file
            print(f"DEBUG: Failed reading {filename} (the file is probably empty, no need to worry)")
            return {}

# A utility function to convert a python datetime into milliseconds from epoch (unix time)
def get_epochtime(dts):
    epoch = dt.utcfromtimestamp(0)
    return (dts - epoch).total_seconds() * 1000.0

# A utility function to help rank user data for all users
def ranker(userdata, index, username, type):
    rankeddata = []
    for i in range(len(userdata)):
        # Ranks start at 1
        rank = i+1
        # If not first index, check if ranks are the same as previous
        if (i > 0) and (userdata[i][index] == userdata[i-1][index]):
            rank = rankeddata[i-1][0]
        # Perform required operations on statistic
        statvalue = userdata[i][index]
        if type == "Distance":
            statvalue = round(statvalue, 2)
        if type == "Time":
            statvalue = int(statvalue/60)
        # Add rank, name, statistic
        rankeddata.append([rank, userdata[i][0], statvalue])

    # See if the user ranked in the top 11
    for i in range(min(11, len(rankeddata))):
        if rankeddata[i][1] == username:
            return rankeddata[0:min(11, len(rankeddata))]

    # If not in top 11, find where the user is and set them as index 11
    # We can assume the location is more than 11, since the first 11 were just cheched
    for i in range(11, len(rankeddata)):
        if rankeddata[i][1] == username:
            # Set position 11 to the user without mutating their overall rank
            rankeddata[10] = rankeddata[i]
            return rankeddata[0:min(11, len(rankeddata))]

    # Usually should not be hit, previously it could in the case that the user had no friends (ie. it was very unfortunate if the code hit this line)
    return []

# Utility function to filter out data from users of same country, preserves sort
def filter_country(sorteduserdata, usercountry):
    filtered = []
    for i in sorteduserdata:
        if countrysettings[i[0]] == usercountry:
            filtered.append(i)
    return filtered

# Utility function to fiter friends of user preserves sort
def filter_friends(sorteduserdata, userfriends, username):
    filtered = []
    for i in sorteduserdata:
        # Check if they are either a friend or the user, we must keep the user in the list so that they can also get a rank relative to their friends
        if i[0] in userfriends or i[0] == username:
            filtered.append(i)
    return filtered

# Utility function to find datetime and epoch of start of most recent Sunday
def week_start_epoch():
    today = datetime.date.today()
    idx = (today.weekday() + 1) % 7
    sun = today - datetime.timedelta(idx)
    sunstart = dt.combine(sun, datetime.time.min)
    epochsunstart = get_epochtime(sunstart)
    epochsunstart = int(epochsunstart)
    return epochsunstart

# Utility function to calculate user data from previous week
def count_week_data(user):
    userruns = os.listdir(user)
    # Tracker variables for user
    distance = 0
    steps = 0
    time = datetime.timedelta()
    # Get week start epoch
    epochsunstart = week_start_epoch()
    # For each run in user
    for run in userruns:
        runstart = int(run[0:-5])
        # If the run was on the week starting Sunday
        if runstart > epochsunstart:
            with open(f'{user}/{run}', 'r') as f:
                rundata = json.load(f)
                # Update all user counter variables
                distance += float(rundata["totalDistance"])
                steps += int(rundata["totalSteps"])
                hrsminsec = rundata["timeString"].split(":")
                # Even though my values are ints, the timedelta function wants floats, so we convert to floats
                time += datetime.timedelta(hours=float(hrsminsec[0]), minutes=float(hrsminsec[1]), seconds=float(hrsminsec[2]))
    # Record data in dictionary for access later
    return [distance, int(time.seconds/60), steps]

# Fill data based on stored files
logins = pickle_loader("logins.txt")
fnames = pickle_loader("fnames.txt")
lnames = pickle_loader("lnames.txt")
locationsettings = pickle_loader("locationsettings.txt")
countrysettings = pickle_loader("countrysettings.txt")
friendsettings = pickle_loader("friendsettings.txt")

################
# HTTP endpoints
################

# The signup endpoint
@app.route('/signup', methods=['POST'])
def signup():
    # Extract data
    record = json.loads(request.data)
    username = record[0]
    password = record[1]
    fname = record[2]
    lname = record[3]
    print(f"SIGNUP: {username} {password} {fname} {lname}")

    # Check if username and password are valid
    if (not username.isalnum() or not password.isalnum() or len(username) > 16 or len(password) > 16):
        return jsonify(False)

    # If username taken disallow sign up
    for key, value in logins.items():
        if key == username:
            return jsonify(False)
    
    # If passes all conditions enact the signup
    logins[username] = hasher(password)
    fnames[username] = fname
    lnames[username] = lname
    locationsettings[username] = True
    countrysettings[username] = "Australia"
    friendsettings[username] = set()    # Use set for faster lookup times
    # Update files with data
    update_file("logins.txt", logins)
    update_file("fnames.txt", fnames)
    update_file("lnames.txt", lnames)
    update_file("locationsettings.txt", locationsettings)
    update_file("countrysettings.txt", countrysettings)
    update_file("friendsettings.txt", friendsettings)
    return jsonify(True)

# The login endpoint
@app.route('/login', methods=['POST'])
def login():
    record = json.loads(request.data)
    username = record[0]
    password = record[1]
    print(f"LOGIN: {username} {password}")
    # Wrap in a try except to stop errors for undefined keys
    try:
        # Check if given password matches the stored password
        if logins[username] == hasher(password):
            # Return success, name and other required data
            return jsonify([True, fnames[username], lnames[username], locationsettings[username], countrysettings[username]])
        else:
            # Send the response as an array with a length of 1, so that client side
            # code can assume it will get an array in response
            return jsonify([False])
    except:
        # This means an invalid username was submitted
        return jsonify([False])

# Endpoint for submitting run data
@app.route('/rundata', methods=['POST'])
def rundata():
    record = json.loads(request.data)
    #print(record)
    time = record["start"]
    username = record["username"]

    # Make sure a directory exists first
    if not os.path.exists(username):
        os.mkdir(username)
    print(f"RUNDATA: {username} sent {time}.json")
    
    # Write the JSON to a file in the folder
    with open(f'{username}/{time}.json', 'w+') as f:
        json.dump(record, f, ensure_ascii=False)
    return jsonify(True)

# Endpoint for getting run data
@app.route('/getrundata', methods=['POST'])
def getrundata():
    record = json.loads(request.data)
    username = record[0]
    needed = record[1]
    print(f"RUNDATA: {username} requested {needed}")

    # Get data
    with open(f'{username}/{needed}', 'r') as f:
        tosend = json.load(f)
        # Yes, we are reading data from json to a python object and then sending it as json
        return jsonify(tosend)

# Endpoint for checking the status of client history cache
@app.route('/historystatus', methods=['POST'])
def historystatus():
    record = json.loads(request.data)
    username = record[0]
    data = record[1]
    print(f"CACHE CHECK: USERNAME: {username}\n DATA: {data}")

    # If user is new, they do not have a folder allocated
    # Ask for any data they have, if they have none, this asks for nothing
    if not os.path.exists(username):
        return jsonify({"error": False, "serverneed": data, "clientneed": []})

    # Check if data needs to be sent between server and client
    serverdata = os.listdir(username)
    serverneed = list(set(data) - set(serverdata))
    clientneed = list(set(serverdata) - set(data))
    
    return jsonify({"error": False, "serverneed": serverneed, "clientneed": clientneed})



# Endpoint for sending current location
@app.route('/sendlocation', methods=['POST'])
def sendlocation():
    record = json.loads(request.data)
    username = record[0]
    lat = record[1]
    long = record[2]
    print(f"LOCATIONSEND: {username} {lat} {long}")

    # Update stored location, use current time for send time
    userlocations[username] = [lat, long, dt.now()]
    return jsonify(True)

# Endpoint for getting locations
@app.route('/getlocations', methods=['POST'])
def getlocations():
    record = json.loads(request.data)
    user = record[0]
    lat = record[1]
    long = record[2]
    userloc = (lat, long)
    print(f"GETLOCATION: from {user} {lat} {long}")

    # Creating things to return
    usernames = []
    lats = []
    longs = []
    distances = []
    names = []
    updated = []

    for key, value in userlocations.items():
        # Dont give the asking user their locaiton back
        if user != key:
            lastupdated = value[2]
            dif = dt.now() - lastupdated
            # Make sure the location update was somewhat recent
            if dif.total_seconds() <= 300:
                # Fill return data
                usernames.append(key)
                lats.append(value[0])
                longs.append(value[1])
                distances.append(int(geopy.distance.geodesic(userloc, (value[0], value[1])).meters))
                names.append(f"{fnames[key]} {lnames[key]}")
                updated.append(int(dif.total_seconds()))
    return jsonify([usernames, names, lats, longs, distances, updated])

# Endpoint for enabling / disabling location feature
@app.route('/locationsetting', methods=['POST'])
def locationsetting():
    record = json.loads(request.data)
    username = record[0]
    settingval = record[1]
    print(f"SETTING: {username} set location tracking to {settingval}")

    if settingval:
        # Enable their location setting
        locationsettings[username] = True
        update_file("locationsettings.txt", locationsettings)
        return jsonify(True)
    else:
        # Disable and remove their current location from server
        locationsettings[username] = False
        del userlocations[username]
        update_file("locationsettings.txt", locationsettings)
        return jsonify(True)
    
# Endpoint for changing country information
@app.route('/countrysetting', methods=['POST'])
def countrysetting():
    record = json.loads(request.data)
    username = record[0]
    settingval = record[1]
    print(f"SETTING: {username} set country to {settingval}")

    # Set new country
    countrysettings[username] = settingval
    return jsonify(True)

# Endpoint for changing first name
@app.route('/firstnames', methods=['POST'])
def firstnamechange():
    record = json.loads(request.data)
    username = record[0]
    settingval = record[1]
    print(f"SETTING: {username} set first name to {settingval}")

    # Set new country
    fnames[username] = settingval
    return jsonify(True)

# Endpoint for changing first name
@app.route('/lastnames', methods=['POST'])
def lstnamechange():
    record = json.loads(request.data)
    username = record[0]
    settingval = record[1]
    print(f"SETTING: {username} set last name to {settingval}")

    # Set new country
    lnames[username] = settingval
    return jsonify(True)

# Endpoint for changing first name
@app.route('/resetdata', methods=['POST'])
def resetdata():
    record = json.loads(request.data)
    username = record[0]
    print(f"SETTING: {username} reset run data")

    # If folder exists, delete user data
    if os.path.exists(username):
        shutil.rmtree(username)
    
    return jsonify(True)

# Endpoint for adding and removing friends
@app.route('/friends', methods=['POST'])
def friendsetting():
    record = json.loads(request.data)
    username = record[0]
    friendname = record[1]
    settingval = record[2]

    status = "friended" if settingval else "unfriended"
    print(f"FRIENDS: {username} {status} {friendname}")
# TODO update friend settings file
    if settingval:
        # If attempting to friend a user
        if friendname in friendsettings[username]:
            # If already friended return false
            return jsonify(False)
        # If not already friended, friend them and update file
        friendsettings[username].add(friendname)
        update_file("friendsettings.txt", friendsettings)
        return jsonify(True)
    
    # If attempting to unfriend a user
    if friendname not in friendsettings[username]:
        # If already not a friend return false
        return jsonify(False)
    # If previously friended, remove them and update file
    friendsettings[username].remove(friendname)
    update_file("friendsettings.txt", friendsettings)
    return jsonify(True)

# Endpoint for getting user data
@app.route('/users', methods=['POST'])
def users():
    record = json.loads(request.data)
    username = record[0]
    requested = record[1]
    print(f"USERS: {username} requested {requested} data")

    # If the user does not exist or is the requester return an error
    if (requested not in logins) or (username == requested):
        return jsonify([False])

    # If no data, dont look for it
    if not os.path.exists(requested):
        return jsonify(f"{fnames[requested]} {lnames[requested]}", (requested in friendsettings[username]), 0, 0, 0, requested, countrysettings[requested])

    userdata = count_week_data(requested)
    distance = round(userdata[0], 2)
    time = userdata[1]
    steps = userdata[2]

    return jsonify(f"{fnames[requested]} {lnames[requested]}", (requested in friendsettings[username]), distance, time, steps, requested, countrysettings[requested])


# Endpoint for getting leaderboard info
@app.route('/leaderboard', methods=['POST'])
def leaderboard():
    record = json.loads(request.data)
    username = record[0]
    print(f"LEADERBOARD: {username} requested leaderboard")

    # Find datetime and epoch of start of most recent Sunday
    epochsunstart = week_start_epoch()

    # Find all users
    users = []
    for key, value in logins.items():
        users.append(key)
    '''
    for folder in os.scandir():
        if folder.is_dir():
            users.append(folder.name)
    # Remove pycache folder if exists
    if (os.path.exists("__pycache__")):
        users.remove("__pycache__")
    '''

    userdataweek = []
    # For each user
    for user in users:
        userruns = []
        if os.path.exists(user):
            userruns = os.listdir(user)
        # Tracker variables for each user
        distance = 0
        steps = 0
        time = datetime.timedelta()
        # For each run in user
        for run in userruns:
            runstart = int(run[0:-5])
            # If the run was on the week starting Sunday
            if runstart > epochsunstart: # check distance-speed hacks before steps hacks
                with open(f'{user}/{run}', 'r') as f:
                    rundata = json.load(f)
                    # If the user is suspected of cheating, dont count this run
                    if (rundata["isCheating"]):
                        continue
                    # Update all user counter variables
                    distance += float(rundata["totalDistance"])
                    steps += int(rundata["totalSteps"])
                    hrsminsec = rundata["timeString"].split(":")
                    # Even though my values are ints, the timedelta function wants floats, so we convert to floats
                    time += datetime.timedelta(hours=float(hrsminsec[0]), minutes=float(hrsminsec[1]), seconds=float(hrsminsec[2]))

        # Record data in dictionary for access later
        userdataweek.append([user, distance, time.seconds, steps])
    
    # Rank all the users for all 3 stat types and 3 stat filters
    usercountry = countrysettings[username]
    userfriends = friendsettings[username]

    #print(userdataweek)

    # Sort based on distance
    userdataweek.sort(key=itemgetter(1), reverse=True)
    worlddistance = ranker(userdataweek, 1, username, "Distance")
    countryonly = filter_country(userdataweek, usercountry)
    countrydistance = ranker(countryonly, 1, username, "Distance")
    friendsonly = filter_friends(userdataweek, userfriends, username)
    friendsdistance = ranker(friendsonly, 1, username, "Distance")

    # Sort based on time
    userdataweek.sort(key=itemgetter(2), reverse=True)
    worldtime = ranker(userdataweek, 2, username, "Time")
    countryonly = filter_country(userdataweek, usercountry)
    countrytime = ranker(countryonly, 2, username, "Time")
    friendsonly = filter_friends(userdataweek, userfriends, username)
    friendstime = ranker(friendsonly, 2, username, "Time")

    # Sort based on steps
    userdataweek.sort(key=itemgetter(3), reverse=True)
    worldsteps = ranker(userdataweek, 3, username, "Steps")
    countryonly = filter_country(userdataweek, usercountry)
    countrysteps = ranker(countryonly, 3, username, "Steps")
    friendsonly = filter_friends(userdataweek, userfriends, username)
    friendssteps = ranker(friendsonly, 3, username, "Steps")

    # Finally return the data
    return jsonify({"worldDistance": worlddistance, "countryDistance": countrydistance, "friendsDistance": friendsdistance, "worldTime": worldtime, "countryTime": countrytime, "friendsTime": friendstime, "worldSteps": worldsteps, "countrySteps": countrysteps, "friendsSteps": friendssteps})


CORS(app)
#app.run(debug=True, port=8080)

# example of another return
#return jsonify({"subjects":subjectsfound, "schools":schoolsfound})

# flask --app server.py  run --host=0.0.0.0 -p 8080
# Ideally run when inside server folder
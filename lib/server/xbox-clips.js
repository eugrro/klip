var XboxLiveAuth = require('@xboxreplay/xboxlive-auth');
var XboxLiveAPI = require('@xboxreplay/xboxlive-api');
var axios = require('axios');
var fs = require('fs');

var myCreds = {
    "uName": 'eugene.rozental@gmail.com',
    "pass": 'IchangedMyPasswordForThisTest'
};


async function getXboxAuthorizationToken(uName, pass) {
    var storedXboxAuthData = fs.readFileSync('./XboxConfig.json');
    var myObj;

    try {
        myObj = JSON.parse(storedXboxAuthData);

        const oneHour = 60 * 60 * 1000;
        var d1 = Date.now();
        var d2 = myObj.lastUpdated;
        console.log("Auth Token Last Updated: " + ((d1 - d2) / oneHour).toFixed(3) + " hours ago");
        if ((d1 - d2) / oneHour > 12) {
            //Need new auth tokens
            const response = await XboxLiveAuth.authenticate(uName, pass);
            response["lastUpdated"] = d1;
            var newData = JSON.stringify(response);
            console.log(newData);
            //newData["lastUpdated"] = d1;
            //console.log(newData);

            fs.writeFile('./XboxConfig.json', newData, function (err) {
                if (err) {
                    console.log('There has been an error saving your configuration data.');
                    console.log(err.message);
                    return "ERROR";
                }
                console.log('New Xbox auth saved successfully.')
            });
            storedXboxAuthData = fs.readFileSync('./XboxConfig.json');
            return `XBL3.0 x=${response.userHash};${response.XSTSToken}`;
        } else {
            //Don't need new auth since it has not expired yet
            return `XBL3.0 x=${myObj.userHash};${myObj.XSTSToken}`;
        }
    }
    catch (err) {
        console.log('There has been an error parsing Xbox JSON Values.')
        console.log(err);
        return "ERROR";
    }
}

async function getPlayerSettings(gamertag, settingVals) {
    try {
        var authTokenValue = await getXboxAuthorizationToken(myCreds.uName, myCreds.pass);
        if (authTokenValue == "ERROR") {
            return -1;
        }
        var stringSettingsVals = settingVals.join(',');

        var ret = await axios({
            url: `https://profile.xboxlive.com/users/gt(${gamertag})/settings?settings=${stringSettingsVals}`,
            method: "GET",
            headers: {
                Authorization: authTokenValue,
                "X-Xbl-Contract-Version": 2,
            },
        });
        //console.log(ret.data.profileUsers[0].id);
        if (ret.data == null) {
            console.log("Error on ret");
            return "ERROR";
        } else {
            console.log("Successfully got Player Settings");
            return ret.data.profileUsers[0].id;
        }
    } catch (err) {
        console.log("Unable to get Player XUID")
        //console.log(err);
        return "ERROR";
    }
};
var authTokenValue;
async function getPlayerXuid(gamertag) {
    try {
        authTokenValue = await getXboxAuthorizationToken(myCreds.uName, myCreds.pass);
        if (authTokenValue == "ERROR") {
            return -1;
        }

        var ret = await axios({
            url: `https://profile.xboxlive.com/users/gt(${gamertag})/settings?settings=`,
            method: "GET",
            headers: {
                Authorization: authTokenValue,
                "X-Xbl-Contract-Version": 2,
            },
        });
        //console.log(ret.data.profileUsers[0].id);
        console.log("Successfully got Player XUID: " + ret.data.profileUsers[0].id);
        return ret.data.profileUsers[0].id;
    } catch (err) {
        console.log("Unable to get Player XUID")
        //console.log(err);
    }
};

async function getPlayerKlips(gamertag) {
    try {
        var userXuid = await getPlayerXuid(gamertag);
        var ret = await axios({
            url: `https://gameclipsmetadata.xboxlive.com/users/xuid(${userXuid})/clips`,
            method: "GET",
            headers: {
                Authorization: authTokenValue,
                "X-Xbl-Contract-Version": 2,
                "X-RequestedServiceVersion": 1,
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Retry-After": 1000,
            },
        });
        //console.log(ret.data.gameClips);
        console.log("Successfully got " + gamertag + "\'s Game Clips");
        return ret.data.gameClips;
    } catch (err) {
        console.log("Unable to get Player Klips");
        console.log(err);
    }
};
//console.log(getXboxAuthorizationToken(myCreds.uName, myCreds.pass));
//getPlayerSettings("eugro", ['UniqueModernGamertag', 'GameDisplayPicRaw', 'Gamerscore', 'Location']);
//console.log(getPlayerXuid("eugro"));
//getPlayerKlips("eugro");

module.exports = {
    getPlayerSettings,
    getPlayerXuid,
    getPlayerKlips,
};

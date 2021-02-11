var XboxLiveAuth = require('@xboxreplay/xboxlive-auth');
var XboxLiveAPI = require('@xboxreplay/xboxlive-api');
var axios = require('axios');
var fs = require('fs');

var myCreds = {
    "uName": 'eugene.rozental@gmail.com',
    "pass": 'IchangedMyPasswordForThisTest'
};

async function getXboxAuthorizationToken(uname, pass) {
    var storedXboxAuthData = fs.readFileSync('./XboxConfig.json');
    var myObj;

    try {
        myObj = JSON.parse(storedXboxAuthData);
        //console.dir(myObj);
        if (Date.parse(myObj.expiresOn) > Date.now) {
            //Need new auth tokens
            console.log("GETTING NEW XBOX AUTH");
            const response = await XboxLiveAuth.authenticate(email, password);
            var newData = JSON.stringify(response);

            fs.writeFile('./XboxConfig.json', newData, function (err) {
                if (err) {
                    console.log('There has been an error saving your configuration data.');
                    console.log(err.message);
                    return;
                }
                console.log('New Xbox auth saved successfully.')
            });
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

        var ret = axios({
            url: `https://profile.xboxlive.com/users/gt(${gamertag})/settings?settings=${stringSettingsVals}`,
            method: "GET",
            headers: {
                Authorization: authTokenValue,
                "X-Xbl-Contract-Version": 2,
            },
        });
        //console.log(ret.data.profileUsers[0].id);
        return ret.data.profileUsers[0].id;
    } catch (err) {
        console.log("Unable to get Player XUID")
        console.log(err);
    }
};
async function getPlayerXuid(gamertag) {
    try {
        var authTokenValue = await getXboxAuthorizationToken(myCreds.uName, myCreds.pass);
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
        return ret.data.profileUsers[0].id;
    } catch (err) {
        console.log("Unable to get Player XUID")
        console.log(err);
    }
};
async function getPlayerKlips(gamertag) {
    try {
        var authTokenValue = await getXboxAuthorizationToken(myCreds.uName, myCreds.pass);
        if (authTokenValue == "ERROR") {
            return -1;
        }
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
        console.log(ret.data);
        return ret.data;
    } catch (err) {
        console.log("Unable to get Player Klips");
        console.log(err);
    }
};

//getPlayerSettings("eugro", ['UniqueModernGamertag', 'GameDisplayPicRaw', 'Gamerscore', 'Location']);
//getPlayerXuid("eugro");
getPlayerKlips("eugro");

module.exports = {
    getPlayerSettings,
    getPlayerXuid,
    getPlayerKlips,
};

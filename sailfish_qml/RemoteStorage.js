.pragma library

var API_URL = ""
var API_KEY = ""


function getAll(API_KEY, onSucess, onError){

    var http = new XMLHttpRequest()
    http.open("GET", API_URL, true);

    // Send the proper header information along with the request
    http.setRequestHeader("Content-type", "application/json");
    http.setRequestHeader("TOKEN", API_KEY);

    http.onreadystatechange = function() { // Call a function when the state changes.
        if (http.readyState == 4) {
            if (http.status == 200) {

                var scores = []
                var recordToHighLight = 0
                var fetchScores = JSON.parse(http.responseText)
                for(var i = 0; i < fetchScores.length; i++){

                    var record = fetchScores[i]
                    scores.push(record)

                }

                onSucess(scores)


            } else {
                console.log("olala error")
                onError(http.status)
            }
        }
    }
    http.send();
}

function canSave(API_KEY, score, onSuccess, onError){
    //check online scores
    var http = new XMLHttpRequest()
    http.open("GET", API_URL + "?operation=canSave&score=" +score, true);

    // Send the proper header information along with the request
    //http.setRequestHeader("Content-type", "application/json");
    http.setRequestHeader("TOKEN", API_KEY);

    http.onreadystatechange = function() { // Call a function when the state changes.
        if (http.readyState == 4) {
            if (http.status == 200) {

                onSuccess(JSON.parse(http.responseText))

                //OK highscore
            } else if (http.status == 0 || http.status >400) {
                //onlineTab.error = true
                onError(http.status)
                console.log("error: " + http.status)

            } else {
               //TODO gameOverItem.isConnected = true
            }
        }
    }
    http.send();
}

function save(API_KEY, UID, data, onSuccess, onError){
    //var scores = []

//    var data = {
//        name: name,
//        score:score,
//        level: level,
//        env: settings.envMode
//    }
    var http = new XMLHttpRequest()
    http.open("POST", API_URL, true);

    // Send the proper header information along with the request
    http.setRequestHeader("Content-Type", "application/json");
    http.setRequestHeader("TOKEN", API_KEY);
    http.setRequestHeader("UID", UID);

    http.onreadystatechange = function() { // Call a function when the state changes.
        if (http.readyState == 4) {
            if (http.status == 201) {

                onSuccess()

                //OK highscore
            } else {
                console.log("error: " + http.status + " resp:" + http.response)
                onError(http.status)
                //onlineTab.error = true


            }
        }
    }
    http.send(JSON.stringify(data));
}



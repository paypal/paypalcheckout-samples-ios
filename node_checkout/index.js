require('dotenv').config();
const express = require('express');
const fetch = require('node-fetch');

let app = express();
let http = require('http').createServer(app);

app.use(express.json());
app.use(express.urlencoded());

// Sandbox testing
const authUrl = "https://api.sandbox.paypal.com/v1/oauth2/token";

app.post("/auth/token", (req, res) => {
    let body = req.body;
    if ("clientId" in body && body.clientId == process.env.CLIENT_ID) {
        const authString = `${process.env.CLIENT_ID}:${process.env.CLIENT_SECRET}`;
        const buffer = Buffer.from(`${authString}`);
        const base64EncodedString = buffer.toString('base64');
        const headers = {
            "Accept": "application/json",
            "Accept-Language": "en_US",
            'Authorization': `Basic ${base64EncodedString}`,
        };
        const formParams = new URLSearchParams();
        formParams.append("grant_type", "client_credentials");
        fetch(authUrl, {
            method: 'POST',
            body: formParams,
            headers: headers
            })
            .then(response => {
                response.json()
                    .then(value => {
                        if ("error" in value) {
                            res.status(400).send(value.error_description);
                        }
                        else {
                            res.status(200).send(value);
                        }
                    })
                    .catch(error => {
                        res.status(400).send(error);
                    })
            })
            .catch(error => {
                res.status(400).send(error);
            });
    }
    else {
        res.status(400).send("No client id");
    }
});

http.listen(3000, () => {
    console.log('Listening on *:3000');
});


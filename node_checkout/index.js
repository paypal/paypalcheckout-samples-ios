require('dotenv').config();
const express = require('express');
const fetch = require('node-fetch');

let app = express();
let http = require('http').createServer(app);
let inspect = require('util').inspect;

app.use(express.json());
app.use(express.urlencoded());

let red = (string) => `\x1b[31m${string}\x1b[0m`
let green = (string) => `\x1b[32m${string}\x1b[0m`

// Sandbox testing
const authUrl = "https://api.sandbox.paypal.com/v1/oauth2/token";

app.post("/auth/token", (req, res) => {
  let body = req.body;

  if (body.clientId) {
    const authString = `${body.clientId}:`;
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
      response
        .json()
        .then(value => {
          if ("error" in value) {
            let message = inspect(
              value.error_description,
              { colors: true }
            )

            console.error(`${red('Error fetching token:')}: ${message}`)
            res.status(400).send(value.error_description);
          }
          else {
            let message = inspect(value, { colors: true })

            console.error(`${green('Successful token fetch')}: ${message}`)
            res.status(200).send(value);
          }
        })
        .catch(error => {
          let message = inspect(error, { colors: true })

          console.error(`${red('Error receiving response')}: ${message}`)
          res.status(400).send(error);
        })
      })
      .catch(error => {
        let message = inspect(error, { colors: true })

        console.error(`${red('fetch() call error')}: ${message}`)
        res.status(400).send(error);
      });
  }
  else {
    console.error(`${red("No client id")}`)
    res.status(400).send("No client id");
  }
});

http.listen(3000, () => {
  console.log('Listening on *:3000');
});

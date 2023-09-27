## Create an easy secure IPv4 HTTPD server on Clear Linux.
Requirements
```txt
Your Domain Registrar Co. needs a custom "A" record that points to your IPv4

Ideally, you'd create a subdomain "A" record

In this example I use clearlinuxbox.*mydomain*.com as a illustration 

clearlinuxbox = subdomain of *mydomain*.com 

```
Temporarily open up port 80 on your router and point it to your LAN IP 

Open up console and sudo the following
```bash
swupd bundle-add  letsencrypt-client
```
Create or edit /etc/hosts with your private LAN IP and then the qualified domain name.

If you have more than one domain just use a comma and add the next
e.g...
```bash
192.168.0.15  clearlinuxbox.*mydomain*.com, someothersubdomain.*mydomain*.com
```

Run certbot

Follow the instructions and when prompted put in your domain name, not the IP

*Note: certbot certs will expire -- I believe in 3 months is default.
In which case you'd just rerun certbot certonly --standalone*
```bash
certbot certonly --standalone
```

Turn off port 80 and turn on port 443 in router

Install nodejs
```bash
swupd bundle-add  nodejs-basic
```
Create a httpd directory to host your website
```bash
mkdir $HOME/public_html
```
Create a file called node.js in the pubic_html folder and add the following

Change clearlinuxbox.\*mydomain\*.com to your domain in all three lines.

```js
const express = require('express')
const app = express()
const fs = require('fs')
const https = require('https')
app.get('/', function(req, res){
    res.sendFile(__dirname + '/index.html');
});

https
  .createServer(
    {
      key: fs.readFileSync('/etc/letsencrypt/live/clearlinuxbox.*mydomain*.com/privkey.pem'),
      cert: fs.readFileSync('/etc/letsencrypt/live/clearlinuxbox.*mydomain*.com/fullchain.pem'),
      ca: fs.readFileSync('/etc/letsencrypt/live/clearlinuxbox.*mydomain*.com/fullchain.pem'),
    },
    app
  )
  .listen(443, () => {
    console.log('Listening...')
  })
```  

Create a file called index.html with some html code and put it in public_html
```html
<h2>Hello World</h2>
```

Install node express module
```bash
npm install express
```

Run the httpd web server
```bash
node node.js
```

Test the webserver *Remember to use HTTPS and not HTTP*
```bash
firefox https://clearlinuxbox.*mydomain*.com
```

Stop the httpd web server
```bash
ctrl_key + c
```

Check for node updates
```bash 
npm update
```

# BorTube Frontend

The frontend of BorTube, making use of Flutter.

## Docker

First build the Docker image: docker build . -t bortube_frontend  
Then run the image: docker run -p 8080:80 --name bortube_frontend bortube_frontend

Open the browser and go to http://localhost:8080

To make the cookies work:

Go into BrowserClient and set withCredentials to true.

Run flutter clean.
Run flutter pub get.

Source: [text](https://medium.com/swlh/flutter-web-node-js-cors-and-cookies-f5db8d6de882)

# BorTube Frontend

The frontend of BorTube, making use of Flutter.

## Docker

First build the Docker image: docker build . -t bortube_frontend  
Then tag it: docker tag bortube_frontend bortubecontainers.azurecr.io/bortube/frontend
Then run the image: docker run -p 8080:80 --name bortube_frontend bortube_frontend
Then push it: docker push bortubecontainers.azurecr.io/bortube/frontend
Then update it: kubectl rollout restart deployment bortube-frontend

Open the browser and go to http://localhost:8080

To make the cookies work:

Go into BrowserClient and set withCredentials to true.

Run flutter clean.
Run flutter pub get.

Source: [text](https://medium.com/swlh/flutter-web-node-js-cors-and-cookies-f5db8d6de882)

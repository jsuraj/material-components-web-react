FROM ubuntu

RUN apt-get update && apt-get install -y git

// https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker
RUN git clone https://github.com/material-components/material-components-web-react.git && cd material-components-web-react

RUN apt-get install chromium-browser
RUN apt-get install wget
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN . ~/.nvm/nvm.sh && nvm install 8
RUN npm install

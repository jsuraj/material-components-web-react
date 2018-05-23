# FROM mhart/alpine-node:latest
#
# RUN apt-get update && apt-get install -y git wget
# RUN apt-get install chromium-browser -y
#
#
# RUN export CHROME_BIN=/usr/bin/chromium-browser
# RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
# RUN . ~/.nvm/nvm.sh; nvm install 8;
# RUN nvm use 8;
#
# RUN apk add git
# RUN git clone https://github.com/material-components/material-components-web-react.git && cd material-components-web-react
# RUN git checkout docker
#
#
# RUN npm install; cd packages/; cd button;npm i;cd ../card;npm i;cd ../fab;npm i;cd ../floating-label;npm i;cd ../line-ripple;npm i;cd ../material-icon;npm i;cd ../notched-outline;npm i;cd ../ripple;npm i;cd ../text-field;npm i;cd ../top-app-bar;npm i;cd ../../;
# RUN npm run test:unit-ci


FROM node:8-slim

# See https://crbug.com/795759
RUN apt-get update && apt-get install -yq libgconf-2-4

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get install -y git wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /src/*.deb

# It's a good idea to use dumb-init to help prevent zombie chrome processes.
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Uncomment to skip the chromium download when installing puppeteer. If you do,
# you'll need to launch puppeteer with:
#     browser.launch({executablePath: 'google-chrome-unstable'})
# ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Install puppeteer so it's available in the container.
RUN npm i puppeteer

# Add user so we don't need --no-sandbox.
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /node_modules

# Run everything after as non-privileged user.
USER pptruser

RUN git clone https://github.com/material-components/material-components-web-react.git && cd material-components-web-react
RUN git checkout docker

RUN npm install; cd packages/; cd button;npm i;cd ../card;npm i;cd ../fab;npm i;cd ../floating-label;npm i;cd ../line-ripple;npm i;cd ../material-icon;npm i;cd ../notched-outline;npm i;cd ../ripple;npm i;cd ../text-field;npm i;cd ../top-app-bar;npm i;cd ../../;
RUN npm run test:unit-ci

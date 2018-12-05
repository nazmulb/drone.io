FROM node:9-alpine
WORKDIR /usr/src/app
ADD server.js .
ADD node_modules node_modules
EXPOSE 3000
CMD [ "node", "server.js" ]

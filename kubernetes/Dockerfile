FROM node:23.5.0-alpine3.20

WORKDIR /src

COPY app/ .

RUN npm install --quiet

EXPOSE 3000

CMD ["npm", "start"]
FROM node:14

# working directory
WORKDIR /app

# copy source code to working directory
COPY ./ .
RUN ls -la

# environment
ENV NODE_ENV=production DB_HOST=item-db

# install dependecny
RUN npm install --production --unsafe-perm && npm run build

# expose port
EXPOSE 8080

# running the app
CMD [ "npm", "start" ]
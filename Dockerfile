# We create a first phase or stage called build-stage
FROM node:alpine AS build-stage

WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . . 
RUN npm run build

# Whenver we want to start another stage/phase we just start another "block" with "FROM", Docker will then know that this is a new phase.
FROM nginx

# The expose command localy doesn't do anything but third party services like AWS Elastic beanstalk use it in order to expose the ports. 
EXPOSE 80

# Note that whenever we copy the result of a previous phase, any content that may have been generated by that previous phase gets marooned
COPY --from=build-stage /app/build/ /usr/share/nginx/html

# The default Nxing image command will start Nxing for us. The final container will only contain the Nxing image with the static files
# created by the previous phase in the /user/share/nxing/html folder but none of the node_modules nor the code.


# Stage 1 : Build... (inchangé)
FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build -- --configuration production

# Stage 2 : Serve
FROM nginx:alpine

# On copie le contenu de 'browser' DIRECTEMENT à la racine web
COPY --from=build app/dist/angular01/browser/ /var/www/html/

# On applique les permissions à la nouvelle racine
RUN chown -R nginx:nginx /var/www/html \
    && chmod -R 755 /var/www/html

# Le reste est inchangé
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx-docker.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

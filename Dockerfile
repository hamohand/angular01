# Stage 1 : Étape de construction: Build the Angular application
FROM node:22-alpine AS build
WORKDIR /app

# Copiez uniquement les fichiers nécessaires pour installer les dépendances
COPY package.json package-lock.json ./

#RUN npm ci
RUN npm install

# Copier le reste du code/application
COPY . .

# et construire l’application Angular
#RUN npm run build

# Assurez-vous que le nom du projet dans "output-path" correspond à votre angular.json
RUN npm run build -- --configuration production

# Stage 2 : Étape de production: Serve the application with Nginx
FROM nginx:alpine

# Copier les fichiers statiques du projet (HTML, CSS, JS)
#COPY dist/angular01/browser /usr/share/nginx/html
COPY --from=build app/dist/angular01/browser/ /var/www/html/angular01
#COPY dist/angular01/browser /var/www/angular01

# Configurer les permissions
RUN chown -R nginx:nginx /var/www/html/angular01 \
    && chmod -R 755 /var/www/html/angular01

# Supprimer la configuration par défaut de Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copier notre propre configuration Nginx
COPY nginx-prod.conf /etc/nginx/conf.d/default.conf

# Exposer le port et exécuter Nginx
EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

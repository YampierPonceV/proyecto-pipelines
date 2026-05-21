# Paso 1: Usar una imagen oficial de Node.js ligera como base
FROM node:20-alpine

# Paso 2: Crear y definir el directorio de trabajo dentro del contenedor
WORKDIR /app

# Paso 3: Copiar los archivos de configuración de dependencias
COPY package*.json ./

# Paso 4: Instalar solo las dependencias necesarias
RUN npm install

# Paso 5: Copiar el resto del código de la aplicación
COPY server.js .

# Paso 6: Exponer el puerto en el que corre la app
EXPOSE 8080

# Paso 7: Comando para ejecutar la aplicación cuando el contenedor inicie
CMD ["npm", "start"]
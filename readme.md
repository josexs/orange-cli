# Orange CLI
Script para generacion de entornos y direct updates en **Orange/Amena**
### Configuracion
Creamos un archivo .env en la raiz con los siguientes datos:
```
pathRepoOrange=""
pathRepoAmena=""
appIdAppCenter=""
```

### Requisitos
- Appcenter CLI
  npm install -g appcenter-cli

- Logarte en Appcenter CLI
  appcenter login y seguir los pasos

  **Nota: APPCenter de momento solo esta implementado en Orange para los APKs**

### Iniciar CLI
- **sh init.sh orange**
- **sh init.sh amena**


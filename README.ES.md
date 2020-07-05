# Vue Deploy a vercel

[🇬🇧 Cambiar a la versión en inglés](README.md)

## Requerimientos

Tenés que tener creada una cuenta en [Vercel](http://vercel.com/).


## Instalá Vercel de manera global
```
npm install -g vercel
```

## Accedé a tu cuenta de Vercel
```
vercel login
```
Te van a enviar un correo a la casilla de e-mail que hayas registrado con tu cuenta para validar tu acceso.


## Creá la configuración del deploy

Dentro de la carpeta `src` crea el archivo `vercel.json` con el siguiente contenido:

```
{
    "version": 2,
    "alias": example.vercel.com 
}
```
(En alias podemos poner el dominio que le vayamos a asignar al deploy)

## Generá el build del proyecto

```
npm run build
```

## Desplegá

```
vercel --prod
```

Vercel te va a generar un link donde podés ver el proceso de deploy, y una vez finalizado vas a poder acceder a tu app desplegada.
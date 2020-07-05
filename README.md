# Vue Deploy to vercel

[🇪🇸 Switch to spanish version](README.ES.md)


## Requirements

You must create a [Vercel](http://vercel.com/) account.


## Install Vercel globally
```
npm install -g vercel
```

## Login to a Vercel account
```
vercel login
```
You will receive an email in the account you registered with vercel, to validate your access.


## Make vercel settings file

In the folder `src` create the file `vercel.json`, with the following text.

```
{
    "version": 2,
    "alias": example.vercel.com 
}
```
(alias = Your deploy domain)

## Compiles for production

```
npm run build
```

## Deploy

```
vercel --prod
```

Vercel will give you a link to view the progress of your deployment, and once completed you can see your application.
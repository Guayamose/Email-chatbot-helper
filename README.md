## Run Locally

Log in into heroku

```bash
  heroku login
```

Stop runing

```bash
  heroku ps:scale web=0 -a email-chatbot-helper
```

Run it again

```bash
  heroku ps:scale web=1 -a email-chatbot-helper
```

# Woblag

Woblag is a Docker image for running Hugo together with Caddy as the server and 
using webhooks to automatically generate the files on updates.

## How to use

```
$ docker run -d \
    -v $(pwd)/Caddyfile:/etc/Caddyfile \
    -v $HOME/.caddy:/etc/.caddy \ 
    -e "REPO_URL=<url of your repository>" \ 
    -e "WEBHOOK_SECRET=<webhook secret>" \ 
    -e "TLS_EMAIL=<your email for certificates>" \ 
    -e "HUGO_BASEURL=<http://www.your.domain/>" \
    -e "HUGO_THEME=stickig" \
    -p 80:80 -p 443:443 \
    couchquid/woblag
```

This will launch Caddy with certificates from LetsEncrypt and autogenerate your blog from the repository.

Here's an example [repo](https://github.com/couchquid/woblag-example-repo) you can use.

## License

See the [LICENSE](LICENSE.md) file for license rights and limitations (MIT).

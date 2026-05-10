# Cloudflare API Token

For TF code in this repository to work it needs a Cloudflare API Token with the following permissions:

- Account -> Workers R2 Storage -> Edit (to create a bucket)
- Account -> Account Rulesets -> Read (to read existing rulesets)
- User -> API Tokens -> Edit (to create bucket access key)
- Zone -> Transform Rules -> Edit (to create a redirection from `/` -> `/index.html` for a public bucket url)
- Zone -> Zone -> Read (to reference the zone in Terraform)
- Zone -> DNS -> Edit (to create DNS records for the niks3 server)

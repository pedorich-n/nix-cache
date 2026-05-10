# Setting up custom domain for a Fly.io

This is for Cloudflare Orange cloud (proxied traffic)

1. Add a domain to fly with `fly certs add <domain>`
2. Get DNS records from fly with `fly certs setup <domain>`
3. Save the DNS records in 1Password under `Fly_domain_DNS` section
4. Run `tofu apply`
5. Check the result with `fly certs check <domain>`

---

Copied from https://fly.io/docs/networking/understanding-cloudflare/

import "dev/justfile.default"

fly-deploy:
    just _run fly-deploy

fly-status:
    just _run fly-status

tofu-plan:
    just _run tofu-plan

tofu-apply:
    just _run tofu-apply

tofu-output:
    just _run tofu-output

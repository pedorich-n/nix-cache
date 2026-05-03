[no-cd]
_run target *args:
    nix run "{{ justfile_directory() + '#' + target }}" {{ if args != "" { '-- ' + args } else { '' } }}

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

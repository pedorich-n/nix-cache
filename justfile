import "dev/justfile.default"

shell *args:
    just _develop "{{ args }}"

fly-deploy *args:
    just _run fly-deploy "{{ args }}"

fly-set-secrets *args:
    just _run fly-set-secrets "{{ args }}"

fly-status *args:
    just _run fly-status "{{ args }}"

tofu-init *args:
    just _run tofu-init "{{ args }}"

tofu-plan *args:
    just _run tofu-plan "{{ args }}"

tofu-apply *args:
    just _run tofu-apply "{{ args }}"

tofu-output *args:
    just _run tofu-output "{{ args }}"

niks3-gc *args:
    just _run niks3-gc "{{ args }}"

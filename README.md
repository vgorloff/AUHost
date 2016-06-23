## Reusable artifacts for projects

### Setting up Subtree

    git subtree add --prefix Vendor/WLConfigOpen https://github.com/vgorloff/WLConfigOpen.git master --squash

### Updating Subtree

    git subtree pull --prefix Vendor/WLConfigOpen https://github.com/vgorloff/WLConfigOpen.git master --squash

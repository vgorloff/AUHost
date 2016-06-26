## Reusable artifacts for generic projects

### Setting up Subtree

    git subtree add --prefix Vendor/WLOpen https://github.com/vgorloff/WLOpen.git master --squash

### Updating Subtree

    git subtree pull --prefix Vendor/WLOpen https://github.com/vgorloff/WLOpen.git master --squash

# Installation et restauration de NixOS-WSL

## Objectif

Reconstruire l'environnement NixOS-WSL à partir du dépôt `nixos-config`, en utilisant Nix Flakes et Home Manager.

**Environnement cible :**
- Windows avec WSL2
- NixOS 26.05
- Utilisateur Linux : `nixos`
- Configuration Flake : `nixosConfigurations.wsl`
- Dépôt local : `/home/nixos/nixos-config`

Cette procédure restaure la configuration déclarative. Les clés privées, les volumes Docker et les données locales nécessitent une restauration séparée.

## 1. Installer WSL

Depuis PowerShell :

```powershell
wsl --version
wsl --list --verbose
```

Si WSL n'est pas installé, suivre la procédure Microsoft d'installation de WSL2.

## 2. Installer NixOS-WSL

Télécharger l'archive `nixos.wsl` depuis les releases officielles :

https://github.com/nix-community/NixOS-WSL/releases

Depuis PowerShell, dans le dossier contenant le fichier :

```powershell
wsl --install --from-file .\nixos.wsl --name NixOS
```

Lancer ensuite :

```powershell
wsl -d NixOS
```

Ne pas écraser une distribution `NixOS` existante. En cas de restauration, préserver préalablement les données de l'ancienne distribution.

## 3. Préparer l'utilisateur

Dans NixOS :

```bash
whoami
passwd
```

Le nom d'utilisateur attendu est `nixos`.

S'assurer que le compte possède un mot de passe valide, car la configuration impose l'authentification sudo.

Initialiser le canal système si nécessaire pour disposer de `nixos-rebuild` :

```bash
sudo nix-channel --update
```

## 4. Récupérer le dépôt

Le dépôt doit être disponible avant la première reconstruction.

Pour un dépôt GitHub public :

```bash
cd ~
git clone <URL-HTTPS-DU-DEPOT> nixos-config
cd nixos-config
```

Pour un dépôt privé, utiliser une authentification Git autorisée ou restaurer d'abord l'identité SSH nécessaire, selon la politique applicable.

Ne pas copier les clés privées dans le dépôt.

Si Git est indisponible dans l'image initiale, utiliser temporairement un environnement Nix fournissant Git ou installer les outils de bootstrap appropriés.

## 5. Vérifier le dépôt

```bash
cd ~/nixos-config

git status
git log -1 --oneline
```

Vérifier notamment la présence de :

```text
flake.nix
flake.lock
hosts/wsl/default.nix
modules/nixos/common.nix
home/common.nix
```

Le fichier `flake.lock` doit être conservé pour reconstruire les versions verrouillées des dépendances.

## 6. Construire NixOS

Si les fonctionnalités Flakes ne sont pas encore activées dans l'installation initiale, les activer temporairement pour les commandes de bootstrap :

```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
```

Puis :

```bash
nix flake check --no-build
nix build --no-link \
  .#nixosConfigurations.wsl.config.system.build.toplevel
```

Examiner les erreurs éventuelles avant d'activer le système.

## 7. Activer la configuration

```bash
sudo nixos-rebuild dry-activate --flake .#wsl
```

Si le résultat est correct :

```bash
sudo nixos-rebuild switch --flake .#wsl
```

La configuration intégrée Home Manager est appliquée par NixOS.

Si les nouveaux paramètres de shell ou de session ne sont pas immédiatement visibles, ouvrir une nouvelle session WSL.

## 8. Vérifier les services

Dans Fish :

```fish
whoami
fish --version
git --version
nvim --version
docker --version
docker compose version
duckdb --version
```

Vérifier Docker rootless :

```fish
systemctl --user is-active docker.service
docker info --format '{{json .SecurityOptions}}'
```

Le service doit être actif et les options Docker doivent inclure `rootless`.

## 9. Restaurer les identités privées

Les identités ne sont pas stockées dans Git.

Éléments à restaurer depuis une sauvegarde sécurisée :

- `~/.ssh` : clés et configuration locale
- `~/.gnupg` : trousseau GnuPG et matériel privé
- `~/.config/sops/age/keys.txt` : identité age
- Autres fichiers de secrets locaux autorisés

Vérifier les permissions :

```fish
stat -c '%a %n' ~/.ssh ~/.gnupg ~/.config/sops/age
stat -c '%a %n' ~/.config/sops/age/keys.txt
```

Valeurs attendues : `700` pour les répertoires privés et `600` pour l'identité age.

Tester séparément SSH, la signature GPG et le déchiffrement age/SOPS.

**Restic vers S3 est prévu, mais pas encore opérationnel.** Ne pas compter sur cette procédure tant que la sauvegarde et la restauration n'ont pas été réellement testées.

## 10. Particularités Neovim

La configuration Neovim utilise actuellement un lien vers les fichiers du dépôt.

Le dépôt doit donc être disponible à :

```text
/home/nixos/nixos-config
```

Si l'utilisateur ou le chemin change, adapter la configuration Home Manager avant la reconstruction.

## 11. Rollback

En cas de problème après une reconstruction :

```fish
sudo nixos-rebuild switch --rollback
```

Cela restaure une précédente génération système disponible, mais ne restaure pas les secrets, les fichiers personnels ou les volumes Docker.

## 12. Limites connues

- La configuration actuelle cible WSL, pas encore un NixOS natif.
- Les noms d'utilisateur et certains chemins restent spécifiques à cette installation.
- Les données professionnelles doivent respecter leurs contraintes de conservation et de stockage.
- Les volumes Docker ne sont pas sauvegardés automatiquement.
- Les sauvegardes Restic/S3 doivent encore être configurées et vérifiées.
- Les opérations de forensic bas niveau ne sont pas toutes compatibles avec WSL.

## 13. Maintenance

Après modification de la configuration :

```fish
cd ~/nixos-config

nix flake check --no-build
and nix build --no-link .#nixosConfigurations.wsl.config.system.build.toplevel
and sudo nixos-rebuild dry-activate --flake .#wsl
```

Puis :

```fish
sudo nixos-rebuild switch --flake .#wsl
```

Mettre à jour volontairement les dépendances :

```fish
nix flake update
git diff -- flake.lock
```

Tester et valider les changements avant de les commiter.

---

Cette documentation décrit l'environnement WSL actuellement utilisé. La procédure de migration vers un laptop NixOS natif sera créée lorsque ce second hôte sera défini.


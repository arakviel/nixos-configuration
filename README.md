# Інструкція з установки NixOS

## Передумови
- `nvme0n1` — основний диск
- Хочемо:
  - `/boot` — 1G
  - `/` — решта простору
- Без окремого `/home`

---

## 1. Видалення старих розділів

```bash
sudo wipefs -a /dev/nvme0n1
sudo parted /dev/nvme0n1 -- mklabel gpt
````

---

## 2. Створення нових розділів

```bash
sudo parted /dev/nvme0n1 -- mkpart primary fat32 1MiB 1GiB
sudo parted /dev/nvme0n1 -- set 1 esp on
sudo parted /dev/nvme0n1 -- mkpart primary ext4 1GiB 100%
```

---

## 3. Форматування

```bash
sudo mkfs.fat -F32 /dev/nvme0n1p1
sudo mkfs.ext4 -L nixos /dev/nvme0n1p2
```

---

## 4. Монтування

```bash
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme0n1p1 /mnt/boot
```

---

## 5. Ініціалізація флейка

```bash
sudo nixos-generate-config --root /mnt
```

> За потреби: замінити `configuration.nix` у `/mnt/etc/nixos/` своїм або використати flake з `flake.nix`.

---

## 6. Встановлення системи (для Flake)

```bash
sudo nixos-install --flake /mnt/etc/nixos#arakviel-pc
```

---

## 7. Перезавантаження

```bash
sudo reboot
```

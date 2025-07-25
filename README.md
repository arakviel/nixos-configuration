# Інструкція з установки NixOS

## Передумови

- `nvme0n1` — основний диск.
- Хочемо:
  - `/boot` — 1 ГБ (FAT32).
  - `/` — 128 ГБ (ext4).
  - `/home` — решта простору (ext4).
- Усі дані на диску `/dev/nvme0n1` будуть видалені.
- Використовуємо Flake з репозиторію `https://github.com/arakviel/nixos-configuration`.

## 1. Видалення старих розділів

Очистіть таблицю розділів на диску:

```bash
sudo wipefs -a /dev/nvme0n1
sudo parted /dev/nvme0n1 -- mklabel gpt
```

## 2. Створення нових розділів

Створіть три розділи: для `/boot`, `/` та `/home`:

```bash
sudo parted /dev/nvme0n1 -- mkpart primary fat32 1MiB 1GiB
sudo parted /dev/nvme0n1 -- set 1 esp on
sudo parted /dev/nvme0n1 -- mkpart primary ext4 1GiB 128GiB
sudo parted /dev/nvme0n1 -- mkpart primary ext4 128GiB 100%
```

Це створить:
- `/dev/nvme0n1p1` — для `/boot` (1 ГБ, FAT32).
- `/dev/nvme0n1p2` — для `/` (128 ГБ, ext4).
- `/dev/nvme0n1p3` — для `/home` (решта простору, ext4).

## 3. Форматування розділів

Відформатуйте розділи:

```bash
sudo mkfs.vfat -F 32 /dev/nvme0n1p1
sudo mkfs.ext4 -L nixos /dev/nvme0n1p2
sudo mkfs.ext4 -L home /dev/nvme0n1p3
```

## 4. Монтування розділів

Змонтуйте розділи в правильному порядку:

```bash
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme0n1p1 /mnt/boot
sudo mkdir -p /mnt/home
sudo mount /dev/disk/by-label/home /mnt/home
```

## 5. Клонування конфігурації Flake

Склонуйте конфігурацію з репозиторію в `/mnt/etc/nixos`:

```bash
sudo mkdir -p /mnt/etc/nixos
sudo git clone https://github.com/arakviel/nixos-configuration.git /mnt/etc/nixos
```

## 6. Ініціалізація конфігурації

Згенеруйте базову конфігурацію NixOS:

```bash
sudo nixos-generate-config --root /mnt
```

Переконайтеся, що файл `/mnt/etc/nixos/configuration.nix` містить коректні налаштування для ваших розділів:

```nix
{
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/home";
    fsType = "ext4";
  };

  boot.loader = {
    systemd-boot.enable = true;  # Для UEFI систем
    efi.canTouchEfiVariables = true;
  };
}
```

**Примітка**: Якщо ви використовуєте BIOS, замініть `systemd-boot` на GRUB:
```nix
boot.loader.grub = {
  enable = true;
  device = "/dev/nvme0n1";
  useOSProber = false;
};
```

## 7. Встановлення системи (для Flake)

Виконайте встановлення, використовуючи Flake з клонованого репозиторію:

```bash
sudo nixos-install --flake /mnt/etc/nixos#arakviel-pc
```

Вас попросять встановити пароль для користувача `root`.

## 8. Перезавантаження

Після встановлення розмонтуйте розділи та перезавантажте систему:

```bash
sudo umount -R /mnt
sudo reboot

## Чому `sudo umount -R /mnt`?

Команда `sudo umount -R /mnt` використовується для рекурсивного розмонтування всіх файлових систем, які були змонтовані в директорію `/mnt` та її піддиректорії. Це необхідно зробити перед перезавантаженням системи після встановлення NixOS, щоб гарантувати, що всі зміни були належним чином записані на диск, і щоб уникнути можливих пошкоджень даних або проблем при завантаженні нової системи. Якщо файлові системи залишаються змонтованими, операційна система може спробувати записати на них дані під час завершення роботи, що може призвести до нестабільного стану або втрати даних.
```

## Зауваження

- **UEFI/BIOS**: Інструкція передбачає UEFI. Для BIOS замініть `systemd-boot` на GRUB у `configuration.nix`.
- **UUID**: Використання `/dev/disk/by-label` є більш надійним, ніж `/dev/nvme0n1pX`. Перегляньте UUID за допомогою:
  ```bash
  lsblk -f
  ```
- **Резервне копіювання**: Усі команди знищують дані на диску `/dev/nvme0n1`. Переконайтеся, що у вас немає важливих даних.
- Якщо Flake у репозиторії потребує специфічних налаштувань, перевірте `flake.nix` у `/mnt/etc/nixos` і адаптуйте його за потреби.

## Автоматичне створення та форматування розділів за допомогою Disko

Виконайте команду для автоматичного створення та форматування розділів:

```bash
sudo nix run github:nix-community/disko -- --mode disko /mnt/etc/nixos/disko-config.nix --root /mnt
```

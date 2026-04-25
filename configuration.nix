# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Turn on ZSTD compression in BTRFS filesystem.
  fileSystems = {
    "/".options = [ "compress-force=zstd" ];
    "/home".options = [ "compress-force=zstd" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable Flake
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];

  # Use latest kernel.
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
  #boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kuala_Lumpur";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ms_MY.UTF-8";
    LC_IDENTIFICATION = "ms_MY.UTF-8";
    LC_MEASUREMENT = "ms_MY.UTF-8";
    LC_MONETARY = "ms_MY.UTF-8";
    LC_NAME = "ms_MY.UTF-8";
    LC_NUMERIC = "ms_MY.UTF-8";
    LC_PAPER = "ms_MY.UTF-8";
    LC_TELEPHONE = "ms_MY.UTF-8";
    LC_TIME = "ms_MY.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;
  hardware.graphics.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = true;
 


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.luqman = {
    isNormalUser = true;
    description = "luqman";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.kcalc
    #  thunderbird
    ];
  };

  ################################################################################################## Install firefox, Nvidia, Steam, Flatpak
  # programs.firefox.enable = true;
  

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
                 modesetting.enable = true;
                 powerManagement.enable = false;
                 powerManagement.finegrained = false;  
                 open = true;          
                 nvidiaSettings = true;
                 
                 package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
                            version = "595.58.03";
                            sha256_64bit = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk=";
                            sha256_aarch64 = "sha256-hzzIKY1Te8QkCBWR+H5k1FB/HK1UgGhai6cl3wEaPT8=";
                            openSha256 = "sha256-6LvJyT0cMXGS290Dh8hd9rc+nYZqBzDIlItOFk8S4n8=";
                            settingsSha256 = "sha256-2vLF5Evl2D6tRQJo0uUyY3tpWqjvJQ0/Rpxan3NOD3c=";
                            persistencedSha256 = "sha256-AtjM/ml/ngZil8DMYNH+P111ohuk9mWw5t4z7CHjPWw=";
                /*
                package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
                            version = "580.126.18";
                            sha256_64bit = "sha256-p3gbLhwtZcZYCRTHbnntRU0ClF34RxHAMwcKCSqatJ0=";
                            sha256_aarch64 = "sha256-pruxWQlLurymRL7PbR24NA6dNowwwX35p6j9mBIDcNs=";
                            openSha256 = "sha256-1Q2wuDdZ6KiA/2L3IDN4WXF8t63V/4+JfrFeADI1Cjg=";
                            settingsSha256 = "sha256-QMx4rUPEGp/8Mc+Bd8UmIet/Qr0GY8bnT/oDN8GAoEI=";
                            persistencedSha256 = "sha256-ZBfPZyQKW9SkVdJ5cy0cxGap2oc7kyYRDOeM0XyfHfI=";
                */
                 };
  };
  

  programs.steam.enable = true;
  programs.git.enable = true;
  programs.neovim.enable = true;
  services.flatpak.enable = true;

  ##################################################################################################


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

  # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  wget
  #  protonup-qt
  bottles
  telegram-desktop
  discord
  #libreoffice
  onlyoffice-desktopeditors 
  protonup-ng
  google-chrome
  whatsapp-electron
  qbittorrent
  vlc
  zoom-us
  rclone
  rclone-browser
  netflix
  lutris
  compsize

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}

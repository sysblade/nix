let
  # User SSH keys (for managing secrets from workstation)
  kedare = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQn06uPFTEWD0XLFPI+z1x73PicyR0wg6i39z4TtlPU";

  # System host keys
  garuda = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK+TzzoaQ3PPw+zG6e1KwPmGpohET2ojzmUN/c4xTm9h root@nixos";

  # TODO: Add other hosts when their SSH keys are available
  # esbcn1-nix-cache1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... root@esbcn1-nix-cache1";
  # esbcn1-nas1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... root@esbcn1-nas1";
  # esbcn1-media1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... root@esbcn1-media1";
  # carbuncle = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... root@carbuncle";
  # bahamut = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... root@bahamut";
in
{
}

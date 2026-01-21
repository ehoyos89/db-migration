{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [ 
    "${modulesPath}/virtualisation/amazon-image.nix" 
  ];
  
  ec2.hvm = true;
  
  environment.systemPackages = with pkgs; [ wireguard-tools vim mysql80 ];
  
  networking.hostName = "wg-server";
  
  # Enable NAT
  networking.nat = {
    enable = true;
    externalInterface = "ens5";
    internalInterfaces = [ "wg0" ];
  };
  
  # Open ports in the firewall
  networking.firewall = {
    allowedTCPPorts = [ 22 3306 ];
    allowedUDPPorts = [ 51820 ];
    extraCommands = '' 
      iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ens5 -j MASQUERADE
      iptables -t nat -A PREROUTING -i ens5 -p tcp --dport 3306 -j DNAT --to-destination 10.100.0.2:3306
      iptables -t nat -A POSTROUTING -d 10.100.0.2 -p tcp --dport 3306 -j MASQUERADE
    '';
  };
  
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      
      # NOTA: Considera usar privateKeyFile en producción
      privateKeyFile = "/etc/wireguard/private.key";
      
      peers = [
        {
          publicKey = "";
          allowedIPs = [ "10.100.0.2/32" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
  
  # Asegurar que IP forwarding esté habilitado
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  # IMPORTANTE: Especifica la versión del sistema
  system.stateVersion = "24.11";
}

{ pkgs, ... }:

let

  hosts = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/StevenBlack/hosts/2c1f72fd4765fcf31cd70134677ecc38ed860589/hosts";
    sha256 = "0v4gzxcvmmcywlrmvlc0222p4js9acg7sfm21902kp8xir70rac2";
  };

in

{
  networking.extraHosts = builtins.readFile hosts;
}
